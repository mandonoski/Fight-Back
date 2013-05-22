//
//  DriversProfile.h
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DriversProfile : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * dlNumber;
@property (nonatomic, retain) NSString * dlState;
@property (nonatomic, retain) NSString * dlExpiration;
@property (nonatomic, retain) NSString * insuranceCompany;
@property (nonatomic, retain) NSString * insurancePolicyNumber;
@property (nonatomic, retain) NSNumber * active;

@end
