//
//  FBDriversViewController.m
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBDriversViewController.h"
#import "FBDriverCell.h"
#import "FBAppDelegate.h"
#import "FBDriverViewController.h"

@interface FBDriversViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) FBAppDelegate *appDelegate;

- (IBAction)createRecord:(id)sender;

@end

@implementation FBDriversViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect mainTableFrame = self.mainTable.frame;
    mainTableFrame.size.height = self.view.frame.size.height - 55;
    self.mainTable.frame = mainTableFrame;
    
}

#pragma mark - Table functionalety

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FBDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FBDriverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - IBActions

- (IBAction)createRecord:(id)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FBDriverViewController *controller = (FBDriverViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBDriverViewController"];
    controller.isEditing = NO;
    [self presentViewController:controller animated:YES completion:nil];
    
}

@end
