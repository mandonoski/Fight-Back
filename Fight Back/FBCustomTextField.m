//
//  FBCustomTextField.m
//  Fight Back
//
//  Created by martin on 5/23/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#define LABEL_TEXT_COLLOR [UIColor colorWithRed:(80/255.f) green:(80/255.f) blue:(80/255.f) alpha:1.0];
#ifdef __IPHONE_6_0
# define ALIGN_RIGHT NSTextAlignmentRight
#else
# define ALIGN_RIGHT UITextAlignmentRight
#endif

#import "FBCustomTextField.h"

@implementation FBCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textColor = LABEL_TEXT_COLLOR;
    self.textAlignment = ALIGN_RIGHT;
}

@end
