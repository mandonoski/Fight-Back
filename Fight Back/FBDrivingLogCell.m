//
//  FBDrivingLogCell.m
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBDrivingLogCell.h"

@implementation FBDrivingLogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        
        UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 28, 340, 10)];
        separator.image = [UIImage imageNamed:@"list_devider.png"];
        [containerView addSubview:separator];
        
        self.dateLabel = [[FBCustomLabel alloc] initWithFrame:CGRectMake(20, 5, 180, 30)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.dateLabel];
        self.dateLabel.text = @"03:03:20 PM";
        
        self.speedLabel = [[FBCustomLabel alloc] initWithFrame:CGRectMake(190, 5, 110, 30)];
        self.speedLabel.backgroundColor = [UIColor clearColor];
        self.speedLabel.textAlignment = NSTextAlignmentRight;
        [containerView addSubview:self.speedLabel];
        self.speedLabel.text = @"999 MPH";
        
        self.noDataCell = [[FBCustomLabel alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
        self.noDataCell.backgroundColor = [UIColor clearColor];
        self.noDataCell.textAlignment = NSTextAlignmentCenter;
        self.noDataCell.text = @"No GPS data availible";
        self.noDataCell.hidden = YES;
        [containerView addSubview:self.noDataCell];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    return self;
    
}

@end
