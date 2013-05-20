//
//  FBViechleViewController.m
//  Fight Back
//
//  Created by martin on 5/20/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBViechleViewController.h"
#import "ViechleProfile.h"

@interface FBViechleViewController ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UISwitch *active;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *makeTextField;
@property (nonatomic, weak) IBOutlet UITextField *colorTextField;

@property(nonatomic, strong) UIImage *offImage;
@property(nonatomic, strong) UIImage *onImage;

- (IBAction)tapRecognized:(id)sender;

@end

@implementation FBViechleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.offImage = [UIImage imageNamed:@"no.png"];
    self.onImage = [UIImage imageNamed:@"yes.png"];
    self.active.onImage = self.onImage;
    self.active.offImage = self.offImage;
}

#pragma mark - Internal Functyonalerty

- (void) dismissKeyboard{
    
    [self.nameTextField resignFirstResponder];
    [self.colorTextField resignFirstResponder];
    [self.makeTextField resignFirstResponder];
    
}

- (void) setAllViechlesInactive{
    
    NSError *error;
    if (![[appDelegate managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViechleProfile"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == %@",[NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSArray *data = [context executeFetchRequest:fetchRequest error:&error];

    if ([data count] > 0) {
        ViechleProfile *activeViechle = [data objectAtIndex:0];
        activeViechle.active = [NSNumber numberWithBool:NO];
        NSError *error;
        if (![[appDelegate managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
}

#pragma mark - IBAActions

- (IBAction)dissmisPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addButtonPressed:(id)sender{
    
    if (self.active.on) {
        [self setAllViechlesInactive];
    }
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    ViechleProfile *viechleProfile = [NSEntityDescription insertNewObjectForEntityForName:@"ViechleProfile" inManagedObjectContext:context];
    viechleProfile.name = self.nameTextField.text;
    viechleProfile.color = self.colorTextField.text;
    viechleProfile.make = self.makeTextField.text;
    
    BOOL active = self.active.on;
    viechleProfile.active = [NSNumber numberWithBool:active];
    
    NSError *error;
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tapRecognized:(id)sender{
    [self dismissKeyboard];
}

@end
