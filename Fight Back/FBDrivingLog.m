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

@interface FBDrivingLog ()

@property (nonatomic, strong) NSArray *logData;
@property (nonatomic, weak) IBOutlet UILabel *averageSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *day;

@end

@implementation FBDrivingLog

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    appDelegate = [[FBAppDelegate alloc] init];
        
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
