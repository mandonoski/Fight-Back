//
//  FBDriverViewController.m
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBDriverViewController.h"
#import "FBCustomTextField.h"
#import "FBCustomLabel.h"

@interface FBDriverViewController ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UISwitch *active;
@property (nonatomic, weak) IBOutlet FBCustomTextField *nameTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *surenameTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *DLNumberTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *DLStateTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *DLExpirationTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *InsurenceCompanyTextField;
@property (nonatomic, weak) IBOutlet FBCustomTextField *InsurancePolicyNumberTextField;
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
- (IBAction)dissmisPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@end

@implementation FBDriverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    appDelegate = (FBAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.offImage = [UIImage imageNamed:@"no.png"];
    self.onImage = [UIImage imageNamed:@"yes.png"];
    self.active.onImage = self.onImage;
    self.active.offImage = self.offImage;
    self.submitButton.titleLabel.textAlignment = ALIGN_CENTER;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textFields = [[NSArray alloc] initWithObjects:self.nameTextField, self.surenameTextField, self.DLExpirationTextField, self.DLNumberTextField, self.DLStateTextField, self.InsurancePolicyNumberTextField, self.InsurenceCompanyTextField, nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.isEditing) {
        self.nameTextField.text = self.editingProfile.firstName;
        self.surenameTextField.text = self.editingProfile.lastName;
        self.DLStateTextField.text = self.editingProfile.dlState;
        self.DLNumberTextField.text = self.editingProfile.dlNumber;
        self.DLExpirationTextField.text = self.editingProfile.dlExpiration;
        self.InsurenceCompanyTextField.text = self.editingProfile.insuranceCompany;
        self.InsurancePolicyNumberTextField.text = self.editingProfile.insurancePolicyNumber;
        self.active.on = [self.editingProfile.active boolValue];
        
        self.submitButton.titleLabel.text = @"Save";
        self.titleLabel.text = @"Edit Driver";
    }
    
}

#pragma mark - Internal Functyonalerty

- (void) dismissKeyboard
{
    
    [self.nameTextField resignFirstResponder];
    [self.surenameTextField resignFirstResponder];
    [self.DLExpirationTextField resignFirstResponder];
    [self.DLNumberTextField resignFirstResponder];
    [self.DLStateTextField resignFirstResponder];
    [self.InsurancePolicyNumberTextField resignFirstResponder];
    [self.InsurenceCompanyTextField resignFirstResponder];
    
}

- (void) editProfile
{
    self.editingProfile.firstName = self.nameTextField.text;
    self.editingProfile.lastName = self.surenameTextField.text;
    self.editingProfile.dlState = self.DLStateTextField.text;
    self.editingProfile.dlNumber = self.DLNumberTextField.text;
    self.editingProfile.dlExpiration = self.DLExpirationTextField.text;
    self.editingProfile.insuranceCompany = self.InsurenceCompanyTextField.text;
    self.editingProfile.insurancePolicyNumber = self.InsurancePolicyNumberTextField.text;
    
    BOOL active = self.active.on;
    self.editingProfile.active = [NSNumber numberWithBool:active];
}

- (void) saveProfile
{
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    DriversProfile *driverProfile = [NSEntityDescription insertNewObjectForEntityForName:@"DriversProfile" inManagedObjectContext:context];
    driverProfile.firstName = self.nameTextField.text;
    driverProfile.lastName = self.surenameTextField.text;
    driverProfile.dlState = self.DLStateTextField.text;
    driverProfile.dlNumber = self.DLNumberTextField.text;
    driverProfile.dlExpiration = self.DLExpirationTextField.text;
    driverProfile.insuranceCompany = self.InsurenceCompanyTextField.text;
    driverProfile.insurancePolicyNumber = self.InsurancePolicyNumberTextField.text;
    
    BOOL active = self.active.on;
    driverProfile.active = [NSNumber numberWithBool:active];
    
}

- (void) setAllDriversInactive
{
    
    NSError *error;
    if (![[appDelegate managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DriversProfile"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == %@",[NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSArray *data = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([data count] > 0) {
        DriversProfile *activeDriver = [data objectAtIndex:0];
        activeDriver.active = [NSNumber numberWithBool:NO];
        NSError *error;
        if (![[appDelegate managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
}

- (BOOL) validateForm{
    
    if ([self.nameTextField.text isEqualToString:@""] ||
        [self.surenameTextField.text isEqualToString:@""]) {
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
            [self setAllDriversInactive];
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
                                                        message:@"Fields: First Name and Last Name are requered"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)tapRecognized:(id)sender{
    [self dismissKeyboard];
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
