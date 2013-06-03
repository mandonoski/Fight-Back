//
//  FBViechleViewController.m
//  Fight Back
//
//  Created by martin on 5/20/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBViechleViewController.h"
#import "FBCustomTextField.h"
#import "FBCustomLabel.h"

@interface FBViechleViewController ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UISwitch *active;
@property (nonatomic, weak) IBOutlet FBCustomTextField *nameTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *makeTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *colorTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *yearTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *LPStateTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *LPNumberTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *VIMTextField;
@property (nonatomic, weak) IBOutlet FBCustomLabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *containerView;

@property(nonatomic, strong) UIImage *offImage;
@property(nonatomic, strong) UIImage *onImage;
@property(nonatomic, strong) NSArray *textFields;

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

- (IBAction)tapRecognized:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

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
    self.submitButton.titleLabel.textAlignment = ALIGN_CENTER;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textFields = [[NSArray alloc] initWithObjects:self.nameTextField, self.makeTextField, self.colorTextField, self.yearTextField, self.LPStateTextField, self.LPNumberTextField, self.VIMTextField, nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isEditing) {
        self.nameTextField.text = self.editingProfile.name;
        self.makeTextField.text = self.editingProfile.make;
        self.colorTextField.text = self.editingProfile.color;
        self.yearTextField.text = self.editingProfile.year;
        self.active.on = [self.editingProfile.active boolValue];
        self.LPStateTextField.text = self.editingProfile.lpState;
        self.LPNumberTextField.text = self.editingProfile.lpNumber;
        self.VIMTextField.text = self.editingProfile.vin;
        
        self.submitButton.titleLabel.text = @"Save";
        self.titleLabel.text = @"Edit Viechle";
    }
    else {
        self.deleteButton.hidden = YES;
    }
}

#pragma mark - Internal Functyonalerty

- (void) dismissKeyboard
{
    
    [self.nameTextField resignFirstResponder];
    [self.colorTextField resignFirstResponder];
    [self.makeTextField resignFirstResponder];
    [self.yearTextField resignFirstResponder];
    [self.VIMTextField resignFirstResponder];
    [self.LPStateTextField resignFirstResponder];
    [self.LPNumberTextField resignFirstResponder];
    
}

- (void) editProfile
{
    self.editingProfile.name = self.nameTextField.text;
    self.editingProfile.color = self.colorTextField.text;
    self.editingProfile.make = self.makeTextField.text;
    self.editingProfile.year = self.yearTextField.text;
    self.editingProfile.vin = self.VIMTextField.text;
    self.editingProfile.lpNumber = self.LPNumberTextField.text;
    self.editingProfile.lpState = self.LPStateTextField.text;
    
    BOOL active = self.active.on;
    self.editingProfile.active = [NSNumber numberWithBool:active];
}

- (void) saveProfile
{
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    ViechleProfile *viechleProfile = [NSEntityDescription insertNewObjectForEntityForName:@"ViechleProfile" inManagedObjectContext:context];
    viechleProfile.name = self.nameTextField.text;
    viechleProfile.color = self.colorTextField.text;
    viechleProfile.make = self.makeTextField.text;
    viechleProfile.year = self.yearTextField.text;
    viechleProfile.vin = self.VIMTextField.text;
    viechleProfile.lpNumber = self.LPNumberTextField.text;
    viechleProfile.lpState = self.LPStateTextField.text;
    
    BOOL active = self.active.on;
    viechleProfile.active = [NSNumber numberWithBool:active];

}

- (void) setAllViechlesInactive
{
    
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

- (BOOL) validateForm{
    
    if ([self.nameTextField.text isEqualToString:@""] ||
        [self.makeTextField.text isEqualToString:@""] ||
        [self.colorTextField.text isEqualToString:@""] ||
        [self.yearTextField.text isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
    
}

#pragma mark - IBAActions

- (IBAction)dissmisPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addButtonPressed:(id)sender{
    
    BOOL valid = [self validateForm];
    
    if (valid) {
        if (self.active.on) {
            [self setAllViechlesInactive];
        }
        
        if (self.isEditing) {
            [self editProfile];
        }
        else {
            [self saveProfile];
        }
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Fields: Year, Make, Model and Color are requered"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)tapRecognized:(id)sender{
    [self dismissKeyboard];
}

- (IBAction)deleteButtonPressed:(id)sender{
    NSError *error;
    if (![[appDelegate managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:self.editingProfile];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIKeyboard Notifications

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float contentOffset = 0;
    float height = self.view.frame.size.height;
    
    for (UITextField *thisTextFIeld in self.textFields){
        if ([thisTextFIeld isFirstResponder]) {
            contentOffset = thisTextFIeld.frame.origin.y-8;
        }
    }   
    
    float permitedOffset = self.view.frame.size.height - keyboardFrame.size.height + contentOffset;
    if (permitedOffset > self.containerView.frame.size.height) {
        contentOffset = contentOffset - (permitedOffset-self.containerView.frame.size.height);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.view.frame = CGRectMake(0,
                                    self.view.frame.origin.y,
                                    self.view.frame.size.width,
                                    (self.view.frame.size.height - keyboardFrame.size.height));
        [self.containerView setContentSize:CGSizeMake(self.containerView.frame.size.width,
                                                     (height))];
        [self.containerView setContentOffset:CGPointMake(0, contentOffset) animated:YES];
    }];
    
}

- (void)keyboardWillDisappear:(NSNotification *)notification
{
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
    [UIView animateWithDuration:0.3 animations:^{
        float height = self.view.frame.size.height;

        self.view.frame = CGRectMake(0,
                                     self.view.frame.origin.y,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height + keyboardFrame.size.height);
        [self.containerView setContentSize:CGSizeMake(self.containerView.frame.size.width,
                                                      (height))];
        
    }];
    
}


@end
