//
//  FBDriverViewController.h
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriversProfile.h"
#import "FBAppDelegate.h"

@interface FBDriverViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>{
    
    FBAppDelegate *appDelegate;
    
}

@property (nonatomic, readwrite) BOOL isEditing;
@property (nonatomic, strong) DriversProfile *editingProfile;

@end
