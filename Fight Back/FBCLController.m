//
//  FBCLController.m
//  Fight Back
//
//  Created by Martin on 5/12/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBCLController.h"

@implementation FBCLController

@synthesize locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 0.5;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        // New property for iOS6
        if ([self.locationManager respondsToSelector:@selector(activityType)]) {
            self.locationManager.activityType = CLActivityTypeFitness;
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", [newLocation description]);
    //NSLog(@"Location: %f", [newLocation speed]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

@end
