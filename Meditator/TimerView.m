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
    CGPathRef path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    [layer setPath:path];
    [layer setStrokeColor:self.tintColor.CGColor];
    [layer setLineWidth:2];
    [layer setStrokeEnd:1];
    [layer setLineCap:kCALineCapRound];
    [layer setFillColor:nil];
    
    CATransform3D transf = CATransform3DMakeRotation(3*M_PI_2, 0, 0, 1);
    self.layer.transform = transf;
}

-(void)setStrokeEnd:(CGFloat)strokeEnd
{
    _strokeEnd = strokeEnd;
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    [layer setStrokeEnd:strokeEnd];
}









@end
