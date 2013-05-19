//
//  ViechleProfile.h
//  Fight Back
//
//  Created by Martin on 5/19/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ViechleProfile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * licencePlate;

@end
