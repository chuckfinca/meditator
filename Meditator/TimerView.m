//
//  TimerView.m
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimerView.h"
@interface TimerView ()

@property (nonatomic) CAShapeLayer *progressLayer;
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
    
    CAShapeLayer *backgroundLayer = (CAShapeLayer *)self.layer;
    [backgroundLayer setPath:path];
    [backgroundLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
    [backgroundLayer setLineWidth:1];
    [backgroundLayer setFillColor:nil];
    [backgroundLayer setLineDashPattern:@[@1,@3,@4,@2]];
    
    
    
    CAShapeLayer *progressLayer = [CAShapeLayer new];
    
    [progressLayer setPath:path];
    [progressLayer setStrokeColor:self.tintColor.CGColor];
    [progressLayer setLineWidth:6];
    [progressLayer setStrokeEnd:1];
    [progressLayer setLineCap:kCALineCapRound];
    [progressLayer setFillColor:nil];
    
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    
    self.transform = CGAffineTransformMakeRotation(3*M_PI/2);
    self.transform = CGAffineTransformTranslate(self.transform, self.bounds.size.width/2, self.bounds.size.height/2);
    self.backgroundColor = [UIColor redColor];
}

-(void)setStrokeEnd:(CGFloat)strokeEnd
{
    _strokeEnd = strokeEnd;
    CAShapeLayer *layer = (CAShapeLayer *)self.progressLayer;
    [layer setStrokeEnd:strokeEnd];
}









@end
