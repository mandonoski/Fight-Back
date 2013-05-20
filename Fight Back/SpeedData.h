//
//  SpeedData.h
//  Fight Back
//
//  Created by martin on 5/20/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SpeedData : NSManagedObject

@property (nonatomic, retain) NSNumber * dataIsValid;
@property (nonatomic, retain) NSString * latitute;
@property (nonatomic, retain) NSString * lontitude;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSDate * timeStamp;

@end
