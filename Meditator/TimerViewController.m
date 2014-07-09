//
//  TimerViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerView.h"

#define NUMBER_OF_TIMER_FIRES 1000

@interface TimerViewController ()

@property (weak, nonatomic) IBOutlet TimerView *timerView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger intervalsRemaining;
@property (nonatomic) float timerInterval;

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Overwritten Methods

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Setup

-(void)setTimerDuration:(NSInteger)minutes
{
    self.timerInterval = (float) minutes*60 / NUMBER_OF_TIMER_FIRES;
    self.intervalsRemaining = NUMBER_OF_TIMER_FIRES;
    self.timer = [NSTimer timerWithTimeInterval:self.timerInterval target:self selector:@selector(updateTimerView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}


#pragma mark - Updating UI

-(void)updateTimerView
{
    self.intervalsRemaining--;
    float percentComplete = (float) self.intervalsRemaining / NUMBER_OF_TIMER_FIRES;
    [self.timerView setStrokeEnd:1-percentComplete];
    
    if(self.intervalsRemaining == 0){
        [self reset];
    }
}


#pragma mark - Timer

-(void)reset
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"TimerViewController didReceiveMemoryWarning...");
}


@end
