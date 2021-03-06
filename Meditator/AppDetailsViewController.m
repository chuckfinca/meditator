//
//  AppDetailsViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppDetailsViewController.h"
#import "AppDictionariesList.h"
#import "RoundedRectButton.h"
#import "FontThemer.h"
#import "GoogleAnalyticsHelper.h"

@interface AppDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet RoundedRectButton *openStoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *appScreenShotImageView;
@property (weak, nonatomic) IBOutlet UILabel *appDescriptionLabel;

@property (nonatomic, strong) NSString *appURLString;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appDescription;
@property (nonatomic, strong) NSString *screenShotName;

@end


@implementation AppDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.iconImageView setImage:[UIImage imageNamed:self.iconName]];
    
    self.appNameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.appName attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    [self.appScreenShotImageView setImage:[UIImage imageNamed:self.screenShotName]];
    self.appDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.appDescription attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    [self.openStoreButton setAttributedTitle:[[NSAttributedString alloc] initWithString:self.openStoreButton.titleLabel.text attributes:[FontThemer sharedInstance].whiteHeadlineTextAttributes] forState:UIControlStateNormal];
    
    [GoogleAnalyticsHelper logEventWithCategory:@"Other App" action:@"View" label:self.appName value:nil];
}

-(void)setupForAppID:(NSInteger)appID
{
    self.appURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%ld?at=1l3vcSo",(long)appID];
    
    NSDictionary *appDictionary = [AppDictionariesList appDictionaryForID:appID];
    self.iconName = appDictionary[APP_ICON_NAME];
    self.appName = appDictionary[APP_NAME];
    self.screenShotName = appDictionary[APP_SCREENSHOT_NAME];
    self.appDescription = [NSString stringWithFormat:@"DESCRIPTION\n\n%@",appDictionary[APP_DESCRIPTION]];
    self.navigationItem.title = appDictionary[APP_SHORT_NAME];
}

-(IBAction)openStore:(id)sender
{
    [GoogleAnalyticsHelper logEventWithCategory:@"Other App" action:@"Open iTunes" label:self.appName value:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appURLString]];
}








@end
