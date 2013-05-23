//
//  FBViechlesViewController.m
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBViechlesViewController.h"
#import "FBVicleCellView.h"
#import "ViechleProfile.h"
#import "FBViechleViewController.h"
#import "FBAppDelegate.h"

@interface FBViechlesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSArray *viechles;
@property (nonatomic, strong) FBAppDelegate *appDelegate;

@end

@implementation FBViechlesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableData];
}

- (NSArray *)getViechles{
    
    NSError *error;
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViechleProfile"
                                              inManagedObjectContext:self.appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *results = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return results;
    
}


- (void)reloadTableData
{
    self.viechles = [NSArray arrayWithArray:[self getViechles]];
    [self.mainTable reloadData];
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
    
    cell.name.text = [thisViechle.make stringByAppendingFormat:@" %@",thisViechle.name];
    cell.yearAndColorLabel.text = [thisViechle.year stringByAppendingFormat:@" / %@",thisViechle.color];
    
    if ([thisViechle.active isEqualToNumber:[NSNumber numberWithBool:YES]]) {
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
    FBViechleViewController *controller = (FBViechleViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBViechleViewController"];
    controller.isEditing = YES;
    ViechleProfile *thisViechle = [self.viechles objectAtIndex:indexPath.row];
    controller.editingProfile = thisViechle;
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - IBActions

- (IBAction)createRecord:(id)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FBViechleViewController *controller = (FBViechleViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FBViechleViewController"];
    controller.isEditing = NO;
    [self presentViewController:controller animated:YES completion:nil];
    
}


@end
