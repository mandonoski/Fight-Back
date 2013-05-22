//
//  FBMasterViewController.h
//  Fight Back
//
//  Created by Martin on 4/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCLController.h"
#import "FBAppDelegate.h"

@interface FBMasterViewController : UIViewController <UITableViewDataSource>{
    
    FBCLController *locationController;
    BOOL isRecording;
    NSTimer *timer;
    FBAppDelegate *appDelegate;

}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (weak) NSTimer *repeatingTimer;
@property (nonatomic) BOOL dataIsValid;

- (NSDictionary *)userInfo;

@end
