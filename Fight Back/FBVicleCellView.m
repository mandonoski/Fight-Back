//
//  FBVicleCellView.m
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBVicleCellView.h"

@implementation FBVicleCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        UIColor *fontColor = [UIColor colorWithRed:121/255 green:121/255 blue:121/255 alpha:1];
        
        self.yearAndColorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];
        self.yearAndColorLabel.backgroundColor = [UIColor clearColor];
        self.yearAndColorLabel.textColor = fontColor;
        [containerView addSubview:self.yearAndColorLabel];
        self.yearAndColorLabel.text = @"Test color";
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 25)];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor = fontColor;
        [containerView addSubview:self.name];
        self.name.text = @"Test Name";
        
        UIImageView *acessory = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 30, 30)];
        acessory.image = [UIImage imageNamed:@"1_navigation_next_item.png"];
        [containerView addSubview:acessory];
        
        UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 10)];
        separator.image = [UIImage imageNamed:@"list_devider.png"];
        [containerView addSubview:separator];
        
        [self addSubview:containerView];
    }
    
    return self;
}

@end
