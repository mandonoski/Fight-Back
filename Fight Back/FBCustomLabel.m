//
//  FBCustomLabel.m
//  Fight Back
//
//  Created by martin on 5/23/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#define LABEL_TEXT_COLLOR [UIColor colorWithRed:(121/255.f) green:(121/255.f) blue:(121/255.f) alpha:1.0];

#import "FBCustomLabel.h"

@implementation FBCustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = LABEL_TEXT_COLLOR
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textColor = LABEL_TEXT_COLLOR;
    
}

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    
    
}


@end
