//
//  TimerView.m
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimerView.h"
@interface TimerView ()

@property (nonatomic) CGFloat strokeEnd;

@end

@implementation TimerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Class)layerClass
{
    return [CAShapeLayer class];
}

-(void)awakeFromNib
{
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    CGPathRef path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    [layer setPath:path];
    [layer setStrokeColor:self.tintColor.CGColor];
    [layer setLineWidth:6];
    [layer setStrokeEnd:0.001];
    [layer setLineCap:kCALineCapRound];
}

-(void)setStrokeEnd:(CGFloat)strokeEnd
{
    _strokeEnd = strokeEnd;
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    [layer setStrokeEnd:strokeEnd];
}









@end
