//
//  AppDetailsViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppDetailsViewController.h"

@interface AppDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openStoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *appScreenShotButton;

@property (nonatomic, strong) NSString *appURLString;

@end


@implementation AppDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.iconImageView setImage:[UIImage imageNamed:@"flowers"]];
    self.appNameLabel.text = @"Guided Mind";
    [self.appScreenShotButton setImage:[UIImage imageNamed:@"blue"]];
}

-(void)setupForAppID:(NSInteger)appID
{
    self.appURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%ld?at=1l3vcSo",(long)appID];
}

-(IBAction)openStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appURLString]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
