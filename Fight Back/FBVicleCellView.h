//
//  FBVicleCellView.h
//  Fight Back
//
//  Created by Martin on 5/4/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCustomLabel.h"

@interface FBVicleCellView : UITableViewCell

@property (nonatomic, strong) FBCustomLabel *yearAndColorLabel;
@property (nonatomic, strong) FBCustomLabel *name;

@end
