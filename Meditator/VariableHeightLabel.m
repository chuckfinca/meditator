//
//  VariableHeightLabel.m
//  mindtimer
//
//  Created by Charles Feinn on 7/25/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "VariableHeightLabel.h"

@implementation VariableHeightLabel

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.bounds.size.width;
}

@end
