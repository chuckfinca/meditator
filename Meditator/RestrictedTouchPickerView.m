//
//  RestrictedTouchPickerView.m
//  mindtimer
//
//  Created by Charles Feinn on 7/22/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RestrictedTouchPickerView.h"

#define IN_BOUNDS_OFFSET_FROM_CENTER_X 25

@implementation RestrictedTouchPickerView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(point.x > self.center.x - IN_BOUNDS_OFFSET_FROM_CENTER_X && point.x < self.center.x + IN_BOUNDS_OFFSET_FROM_CENTER_X){
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

@end
