
//
//  FBMasterViewController.m
//  Fight Back
//
//  Created by Martin on 4/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBMasterViewController.h"
#import "SpeedData.h"
#import "TTLocationHandler.h"
#import "FBViechlesViewController.h"
#import "FBDriversViewController.h"

@interface FBMasterViewController ()

@property (nonatomic, strong) IBOutlet UIView *tableViewHolder;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) FBViechlesViewController *viechlesView;
@property (nonatomic, strong) FBDriversViewController *driversView;

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
    
    [self addViechleTable];
    [self addDriversTable];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) addViechleTable
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.viechlesView = (FBViechlesViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBViechlesViewController"];
    self.viechlesView.view.frame = CGRectMake(0, 0, self.tableViewHolder.frame.size.width, self.tableViewHolder.frame.size.height);
    [self addChildViewController:self.viechlesView];
    [self.tableViewHolder addSubview:self.viechlesView.view];
}

- (void) addDriversTable
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.driversView = (FBDriversViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBDriversViewController"];
    self.driversView.view.frame = CGRectMake(0, 0, self.tableViewHolder.frame.size.width, self.tableViewHolder.frame.size.height);
    [self addChildViewController:self.driversView];
    [self.tableViewHolder addSubview:self.driversView.view];
    self.driversView.view.alpha = 0;
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
    
    if ([appDelegate checkIfUsersAreAdded] && [appDelegate checkIfViechlesAreAdded]) {
        if ([appDelegate getActiveDriver] && [appDelegate getActiveViechle]) {
            if(isRecording){
                isRecording = NO;
                [self.repeatingTimer invalidate];
                self.repeatingTimer = nil;
                [self.recordButton setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
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
                [self.recordButton setImage:[UIImage imageNamed:@"stop_record.png"] forState:UIControlStateNormal];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"No active driver or viechle selected"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        if (![appDelegate checkIfViechlesAreAdded]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"No Viechles added. You need to add and make one active to be able to generate log"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        } else if (![appDelegate checkIfUsersAreAdded]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"No drivers added. You need to add and make one active to be able to generate log"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}

- (IBAction)viechlesPressed:(id)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.driversView.view.alpha = 0.0;
         
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viechlesView.view.alpha = 1.0;
        }];
    }];
    
}

- (IBAction)driversPressed:(id)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viechlesView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.driversView.view.alpha = 1.0;
        }];
    }];
    
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

- (void) writeInDbWithLocation:(CLLocation *)currentLocation{
    
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    SpeedData *speedData = [NSEntityDescription insertNewObjectForEntityForName:@"SpeedData" inManagedObjectContext:context];
    speedData.speed = [@"" stringByAppendingFormat:@"%f",[currentLocation speed]];
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
