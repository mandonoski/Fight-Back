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
#import "DriversProfile.h"

@interface FBDriversViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSArray *users;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableData];
}

- (void) reloadTableData
{
    self.users = [NSArray arrayWithArray:[self getUsers]];
    [self.mainTable reloadData];
}

- (NSArray *)getUsers{
    
    NSError *error;
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DriversProfile"
                                              inManagedObjectContext:self.appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *results = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
    
}


#pragma mark - Table functionalety

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
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
    
    DriversProfile *thisProfile = [self.users objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = thisProfile.firstName;
    cell.surnameLabel.text = thisProfile.lastName;
    
    if ([thisProfile.active isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FBDriverViewController *controller = (FBDriverViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBDriverViewController"];
    controller.isEditing = YES;
    DriversProfile *thisViechle = [self.users objectAtIndex:indexPath.row];
    controller.editingProfile = thisViechle;
    [self presentViewController:controller animated:YES completion:nil];

    
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
