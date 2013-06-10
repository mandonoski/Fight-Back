//
//  LogDates.h
//  Fight Back
//
//  Created by Martin on 6/5/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LogDates : NSManagedObject

@property (nonatomic, retain) NSString * start;
@property (nonatomic, retain) NSString * end;
@property (nonatomic, retain) NSString * boughtDate;

@end
