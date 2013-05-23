//
//  FBDrivingLogCell.h
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCustomLabel.h"

@interface FBDrivingLogCell : UITableViewCell

@property (nonatomic, strong) FBCustomLabel *dateLabel;
@property (nonatomic, strong) FBCustomLabel *speedLabel;
@property (nonatomic, strong) FBCustomLabel *noDataCell;

@end
