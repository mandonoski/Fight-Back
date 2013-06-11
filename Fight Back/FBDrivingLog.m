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

#define CONVERSION_RATE_KM 1000
#define CONVERSION_RATE_M 1609.34
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface FBDrivingLog () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *logData;
@property (nonatomic, weak) IBOutlet FBCustomLabel *averageSpeedLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *maxSpeedLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *startDateLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *endDateLabel;
@property (nonatomic, weak) IBOutlet FBCustomLabel *day;
@property (nonatomic, weak) IBOutlet FBCustomLabel *driverName;
@property (nonatomic, weak) IBOutlet FBCustomLabel *viechleName;
@property (nonatomic, weak) IBOutlet FBCustomLabel *mesurementType1;
@property (nonatomic, weak) IBOutlet FBCustomLabel *mesurementType2;
@property (nonatomic, weak) IBOutlet UITableView *mainTable;
@property (nonatomic, weak) IBOutlet UISwitch *systemSwitch;
@property (nonatomic, strong) UITextField *utextfield;

@property (nonatomic) BOOL miles;

-(IBAction)buyPdfPressed:(id)sender;

@end

@implementation FBDrivingLog

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.logData = [appDelegate generateLog];
    
    self.miles = YES;
    
    [self loadData];
    
}

- (double) convertSpeed:(double) speed{
    
    double convertedValue = 0;
    
    if (self.miles) {
        convertedValue = speed*3600/CONVERSION_RATE_M;
    }
    else{
        convertedValue = speed*3600/CONVERSION_RATE_KM;
    }
    
    return convertedValue;
    
}

- (void)loadData{
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
    self.maxSpeedLabel.text = [@"" stringByAppendingFormat:@"%.02f",[self convertSpeed:max]];
    self.averageSpeedLabel.text = [@"" stringByAppendingFormat:@"%.02f",[self convertSpeed:average]];
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
    
    if (self.miles) {
        self.mesurementType1.text = @"MPH";
        self.mesurementType2.text = @"MPH";
    }
    else {
        self.mesurementType1.text = @"KMH";
        self.mesurementType2.text = @"KMH";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) checkConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        /*UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
        [errorView autorelease];*/
        return NO;
    }
    else {
        return YES;
    }
    
}

#pragma mark - IBActions

- (IBAction)switchPressed:(id)sender{
    
    self.miles = !self.miles;
    [self loadData];
    [self.mainTable reloadData];
    
}

- (IBAction)dissmisPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)buyPdfPressed:(id)sender{
    if ([self checkConnection]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Enter email"
                                                        message:@"The generated pdf will be sent to:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.utextfield = [alert textFieldAtIndex:0];
        self.utextfield.placeholder = @"email";
        self.utextfield.keyboardType = UIKeyboardTypeEmailAddress;
        
        /*self.utextfield = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        self.utextfield.placeholder = @"email";
        self.utextfield.keyboardType = UIKeyboardTypeEmailAddress;
        [self.utextfield becomeFirstResponder];
        [self.utextfield setBackgroundColor:[UIColor whiteColor]];
        [alert addSubview:self.utextfield];*/
        
        [alert show];
    }
    else {
        UIAlertView *errorView;
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to sent the data required for the pdf.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }
    
    
    
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1 && ![self.utextfield.text isEqual: @""]) {
        dispatch_async(kBgQueue, ^{
            NSString *email = self.utextfield.text;
            NSString *maxSpeed = self.maxSpeedLabel.text;
            NSString *averageSpeed = self.averageSpeedLabel.text;
            NSString *driver = self.driverName.text;
            NSString *viechle = self.viechleName.text;
            NSString *theDate = self.day.text;
            NSString *endTime = self.endDateLabel.text;
            NSString *stratTime = self.startDateLabel.text;
            NSString *times = @"";
            NSString *speeds = @"";
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm:ss"];
            
            for (int i = 0; i < ([self.logData count]-1); i++) {
                
                SpeedData *thisRecord = [self.logData objectAtIndex:i];
                
                NSString *time = [formatter stringFromDate:thisRecord.timeStamp];
                NSString *speed = [@"" stringByAppendingFormat:@"%.02f",[thisRecord.speed doubleValue]];
                
                times = [times stringByAppendingFormat:@"%@,",time];
                speeds = [speeds stringByAppendingFormat:@"%@,",speed];
                
            }
            
            SpeedData *thisRecord = [self.logData lastObject];
            
            times = [times stringByAppendingFormat:@"%@",[formatter stringFromDate:thisRecord.timeStamp]];
            speeds = [speeds stringByAppendingFormat:@"%@",[@"" stringByAppendingFormat:@"%.02f",[thisRecord.speed doubleValue]]];
            
            NSString *utlString = [@"" stringByAppendingFormat:@"http://www.myspeedwitness.com/mac/generate.php?receiver=%@&max=%@&avg=%@&date=%@&time_start=%@&time_end=%@&driver=%@&vehicle=%@&times=%@&speed=%@", email, maxSpeed, averageSpeed, theDate, stratTime, endTime, driver, viechle, times, speeds];
            
            NSURL *requestUrl  =[NSURL URLWithString:[utlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSData* data = [NSData dataWithContentsOfURL:requestUrl];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
        
    }
    else {
        return;
    }
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"status"]; //2
    
    NSLog(@"succes: %@", latestLoans); //3
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
        //[formatter setDateFormat:@"HH:mm:ss MM/dd/yyyy"];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *stringDateRepresentation = [formatter stringFromDate:thisRow.timeStamp];
        
        cell.dateLabel.text = stringDateRepresentation;
        float speed = [thisRow.speed floatValue];
        
        NSString *indicator = @"";
        if (self.miles) {
            indicator = @"MPH";
        }
        else {
            indicator = @"km/h";
        }
        
        cell.speedLabel.text = [@"" stringByAppendingFormat:@"%.02f %@",[self convertSpeed:speed], indicator];
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
