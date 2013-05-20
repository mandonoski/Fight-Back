
//
//  FBMasterViewController.m
//  Fight Back
//
//  Created by Martin on 4/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBMasterViewController.h"
#import "FBVicleCellView.h"
#import "SpeedData.h"
#import "TTLocationHandler.h"
#import "ViechleProfile.h"

#define CONVERSION_RATE 1000

@interface FBMasterViewController ()

@property (nonatomic, weak) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSArray *viechles;

@end

@implementation FBMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    isRecording = NO;
    
    locationController = [[FBCLController alloc] init];
    appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];//[[FBAppDelegate alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self reloadTableData];
    
}

#pragma mark - Internal Func

- (void)reloadTableData
{
    self.viechles = [NSArray arrayWithArray:[self getViechles]];
    [self.mainTable reloadData];
}

- (NSArray *)getViechles{
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViechleProfile"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
    
}

#pragma mark - Table functionalety

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viechles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    static NSString *CellIdentifier = @"Cell";
    
    FBVicleCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FBVicleCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ViechleProfile *thisViechle = [self.viechles objectAtIndex:indexPath.row];
    
    cell.name.text = thisViechle.name;
    cell.yearAndColorLabel.text = thisViechle.color;
    if (thisViechle.active) {
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

#pragma mark - dbHelper

- (void) saveContext{
    
    NSError *error;
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

#pragma mark - IBActions

- (IBAction)logPressed:(id)sender{
    if ([[appDelegate generateLog] count]>0) {
        [self performSegueWithIdentifier:@"goToLog" sender:self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"No data to display. Pres start record to generate some data"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
     
}

- (IBAction)recordPressed:(id)sender{
    
    if(isRecording){
        isRecording = NO;
        [self.repeatingTimer invalidate];
        self.repeatingTimer = nil;
        //appDelegate.sharedLocationHandler.writesToDatabase = NO;
    }
    else {
        isRecording = YES;
        
        NSLog(@"Location: %@", [locationController.locationManager.location description]);
        [self writeInDbWithLocation:locationController.locationManager.location];
        
        self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                               target:self
                                                             selector:@selector(targetMethod:)
                                                             userInfo:[self userInfo]
                                                              repeats:YES];
        /*NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop addTimer:self.repeatingTimer forMode:NSRunLoopCommonModes];
        [loop run];*/

        //appDelegate.sharedLocationHandler.writesToDatabase = YES;
    }
    
}

#pragma mark - NSTimer

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

- (void)targetMethod:(NSTimer*)theTimer {
    
    NSLog(@"Location: %@", [locationController.locationManager.location description]);
    [self writeInDbWithLocation:locationController.locationManager.location];
    
}

- (void)invocationMethod:(NSDate *)date {
    NSLog(@"Invocation for timer started on %@", date);
}

- (IBAction)startOneOffTimer:sender {
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:[self userInfo]
                                    repeats:NO];
}

- (void) writeInDbWithLocation:(CLLocation *)currentLocation{
    
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    SpeedData *speedData = [NSEntityDescription insertNewObjectForEntityForName:@"SpeedData" inManagedObjectContext:context];
    speedData.speed = [@"" stringByAppendingFormat:@"%f",([currentLocation speed]*3600/CONVERSION_RATE)];
    speedData.latitute = [@"" stringByAppendingFormat:@"%f",currentLocation.coordinate.latitude];
    speedData.lontitude = [@"" stringByAppendingFormat:@"%f",currentLocation.coordinate.longitude];
    speedData.timeStamp = [NSDate date];
    if (currentLocation && [currentLocation speed]>-1) {
        speedData.dataIsValid = [NSNumber numberWithBool:YES];
    }
    else {
        speedData.dataIsValid = [NSNumber numberWithBool:NO];
    }
    NSError *error;
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }


}

@end
