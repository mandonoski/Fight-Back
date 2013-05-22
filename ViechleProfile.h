//
//  ViechleProfile.h
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ViechleProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * lpState;
@property (nonatomic, retain) NSString * lpNumber;
@property (nonatomic, retain) NSString * vin;

@end
