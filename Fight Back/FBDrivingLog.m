//
//  FBDrivingLog.m
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBDrivingLog.h"
#import "FBDrivingLogCell.h"
#import "SpeedData.h"
#import "DriversProfile.h"
#import "ViechleProfile.h"
#import "FBCustomLabel.h"

@interface FBDrivingLog ()

@property (nonatomic, strong) NSArray *logData;
@property (nonatomic, weak) IBOutlet FBCustomLabel *averageSpeedLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *maxSpeedLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *startDateLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *endDateLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *day;
@property (nonatomic, weak) IBOutlet FBCustomLabel *driverName;
@property (nonatomic, weak) IBOutlet FBCustomLabel *viechleName;

@end

@implementation FBDrivingLog

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    self.logData = [appDelegate generateLog];
    
    double max = 0.0;
    double average = 0.0;
    NSString *stratDate = @"";
    NSString *endDate = @"";
    NSString *day;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    for (int i = 0; i<[self.logData count]; i++) {
        SpeedData* thisSpeedData = [self.logData objectAtIndex:i];
        if (i == 0) {
            stratDate = [formatter stringFromDate:thisSpeedData.timeStamp];
        } else if (i == ([self.logData count]-1)){
            endDate = [formatter stringFromDate:thisSpeedData.timeStamp];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            day = [formatter stringFromDate:thisSpeedData.timeStamp];
        }
        if (max<[thisSpeedData.speed doubleValue]) {
            max = [thisSpeedData.speed doubleValue];
        }
        average += [thisSpeedData.speed doubleValue];
    }
    average = average/[self.logData count];
    self.maxSpeedLabel.text = [@"" stringByAppendingFormat:@"%.02f",max];
    self.averageSpeedLabel.text = [@"" stringByAppendingFormat:@"%.02f",average];
    self.startDateLabel.text = stratDate;
    self.endDateLabel.text = endDate;
    self.day.text = day;
    
    DriversProfile *activeDriver = [appDelegate getActiveDriver];
    ViechleProfile *activeViechle = [appDelegate getActiveViechle];
	if (activeDriver) {
        self.driverName.text = [activeDriver.firstName stringByAppendingFormat:@" %@",activeDriver.lastName];
    }
    else {
        self.driverName.text = @"No driver set as active";
    }
    
    if (activeViechle) {
        self.viechleName.text = [activeViechle.name stringByAppendingFormat:@"/%@ %@",activeViechle.color, activeViechle.make];
    }
    else {
        self.viechleName.text = @"No viechle set as active";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)dissmisPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table functionalety

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FBDrivingLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FBDrivingLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SpeedData *thisRow = [self.logData objectAtIndex:indexPath.row];
    if ([thisRow.dataIsValid isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss MM/dd/yyyy"];
        NSString *stringDateRepresentation = [formatter stringFromDate:thisRow.timeStamp];
        
        cell.dateLabel.text = stringDateRepresentation;
        float speed = [thisRow.speed floatValue];
        cell.speedLabel.text = [@"" stringByAppendingFormat:@"%.02f km/h",speed];
        cell.dateLabel.hidden = NO;
        cell.speedLabel.hidden = NO;
        cell.noDataCell.hidden = YES;
    }
    else {
        cell.dateLabel.hidden = YES;
        cell.speedLabel.hidden = YES;
        cell.noDataCell.hidden = NO;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
