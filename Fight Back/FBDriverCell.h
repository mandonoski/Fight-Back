//
//  FBDriverCell.h
//  Fight Back
//
//  Created by martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCustomLabel.h"

@interface FBDriverCell : UITableViewCell

@property (nonatomic, strong) FBCustomLabel *nameLabel;
@property (nonatomic, strong) FBCustomLabel *surnameLabel;

@end
