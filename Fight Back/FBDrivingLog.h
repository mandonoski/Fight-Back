//
//  FBDrivingLog.h
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBAppDelegate.h"
#import "Reachability.h"

@interface FBDrivingLog : UIViewController{
    
    FBAppDelegate *appDelegate;
    Reachability *internetReachableFoo;
    
}

- (IBAction)dissmisPressed:(id)sender;

@end
