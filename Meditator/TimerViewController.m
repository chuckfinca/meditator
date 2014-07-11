//
//  TimerViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerView.h"
#import "Timer.h"
#import "UIImage+BlurEffects.h"

#define NUMBER_OF_TIMER_FIRES 1000

@interface TimerViewController () <TimerViewDelegate>

@property (weak, nonatomic) IBOutlet TimerView *timerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

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
    
    
    UIColor *tintColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.backgroundImageView.image = [[UIImage imageNamed:@"flowers"] applyBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:0.8 maskImage:nil];
    
    self.statusLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Overwritten Methods

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Setup

-(void)setTimerDuration:(NSInteger)minutes
{
    Timer *timer = [Timer sharedInstance];
    timer.delegate = self;
    [timer startTimerWithDuration:minutes];
}



#pragma mark - Timer

-(void)reset
{
    [[Timer sharedInstance] reset];
}


#pragma mark - TimerViewDelegate

-(void)updateTimerViewWithCompletionPercentage:(float)percentComplete
{
    [self.timerView setStrokeEnd:percentComplete];
}


#pragma mark - Target Action

-(IBAction)pause:(id)sender
{
    Timer *timer = [Timer sharedInstance];
    if(timer.timerIsRunning){
        [timer pause];
    } else {
        [timer resume];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"TimerViewController didReceiveMemoryWarning...");
}








@end
