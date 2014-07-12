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
#import "MorphingTimerLabel.h"

#define NUMBER_OF_TIMER_FIRES 1000

@interface TimerViewController () <TimerViewDelegate>

@property (weak, nonatomic) IBOutlet TimerView *timerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet MorphingTimerLabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

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
    self.statusLabel.alpha = 0;
    
    [self.pauseButton setImage:[[UIImage imageNamed:@"pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.pauseButton.tintColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.pauseButton.alpha = 0;
    
    self.endButton.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.statusLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.statusLabel.alpha = 0;
            self.pauseButton.alpha = 1;
            self.endButton.alpha = 1;
        } completion:^(BOOL finished) {
            [[Timer sharedInstance] start];
        }];
    }];
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
    [timer setupTimerWithDuration:minutes*60];
}


#pragma mark - TimerViewDelegate

-(void)updateTimerView:(float)percentRemaining
{
    [self.timerView setStrokeEnd:percentRemaining];
    
    if(percentRemaining < .01){
        [self.pauseButton setTitle:@"meditation complete" forState:UIControlStateNormal];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ReturnToSettings"]){
        [[Timer sharedInstance] reset];
    }
}

#pragma mark - Target Action

-(IBAction)pause:(id)sender
{
    Timer *timer = [Timer sharedInstance];
    BOOL timerWasRunning = timer.timerIsRunning;
    
    [timer pause];
    
    NSInteger secondsRemaining = timer.remainingTimerDuration;
    
    if(secondsRemaining == 0){
        [self performSegueWithIdentifier:@"ReturnToSettings" sender:self];
        
    } else if(timerWasRunning){
        
        [self.statusLabel setupForTime:secondsRemaining];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.statusLabel.alpha = 1.0;
            [self.pauseButton setImage:[[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {}];
        
        
    } else {
        [timer start];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.statusLabel.alpha = 0;
            [self.pauseButton setImage:[[UIImage imageNamed:@"pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {}];
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"TimerViewController didReceiveMemoryWarning...");
}








@end
