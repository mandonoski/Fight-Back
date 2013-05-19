//
//  SpeedData.h
//  Fight Back
//
//  Created by Martin on 5/19/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SpeedData : NSManagedObject

@property (nonatomic, retain) NSString * latitute;
@property (nonatomic, retain) NSString * lontitude;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * dataIsValid;

@end
