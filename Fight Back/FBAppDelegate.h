//
//  FBAppDelegate.h
//  Fight Back
//
//  Created by Martin on 4/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPDeepSleepPreventer.h"
#import "FBCLController.h"
#import "DriversProfile.h"
#import "ViechleProfile.h"

@class TTLocationHandler;

@interface FBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSArray *logData;
@property (nonatomic, strong) MMPDeepSleepPreventer *deepSleepPreventer;
@property (nonatomic, strong) FBCLController *locationController;
@property (nonatomic, strong) TTLocationHandler *sharedLocationHandler;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)generateLog;
+ (void) gpsOn;
+ (void) gpsOff;
- (ViechleProfile *) getActiveViechle;
- (DriversProfile *) getActiveDriver;

@end
