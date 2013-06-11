//
//  FBDriverCell.m
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FBDriverCell.h"

@implementation FBDriverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        self.nameLabel = [[FBCustomLabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.nameLabel];
        self.nameLabel.text = @"Name";
        
        self.surnameLabel = [[FBCustomLabel alloc] initWithFrame:CGRectMake(30, 30, 200, 25)];
        self.surnameLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.surnameLabel];
        self.surnameLabel.text = @"Surname";
        
        UIImageView *acessory = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 30, 30)];
        acessory.image = [UIImage imageNamed:@"1_navigation_next_item.png"];
        [containerView addSubview:acessory];
        
        UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 10)];
        separator.image = [UIImage imageNamed:@"list_devider.png"];
        [containerView addSubview:separator];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
