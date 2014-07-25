//
//  RoundedRectButton.m
//  mindtimer
//
//  Created by Charles Feinn on 7/24/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RoundedRectButton.h"

@implementation RoundedRectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.titleLabel.textColor = [UIColor whiteColor];
    self.layer.backgroundColor = self.tintColor.CGColor;
    self.layer.cornerRadius = 4;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
