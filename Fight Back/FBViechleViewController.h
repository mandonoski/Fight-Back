//
//  FBViechleViewController.h
//  Fight Back
//
//  Created by martin on 5/20/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBAppDelegate.h"
#import "ViechleProfile.h"

@interface FBViechleViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>{
    
    FBAppDelegate *appDelegate;
    
}

@property (nonatomic, readwrite) BOOL isEditing;
@property (nonatomic, strong) ViechleProfile *editingProfile;

@end
