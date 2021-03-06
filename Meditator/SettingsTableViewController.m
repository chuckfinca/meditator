//
//  SettingsTableViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "IntervalCell.h"
#import "ChimeSelectorCell.h"
#import "TimerViewController.h"
#import "IntervalCellDelegateAndDataSource.h"
#import "StartCell.h"
#import "MindTimerIAPHelper.h"
#import "SoundEffectPlayer.h"
#import "Purchaser.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "GoogleAnalyticsHelper.h"
#import "RequestPermissionsCell.h"

#define SELECTED_SOUND_INDEX @"SelectedSoundIndex"
#define SELECTED_BACKGROUND_INDEX @"SelectedBackgroundIndex"
#define DISPLAY_INTERVALS @"DisplayIntervals"
#define TIMER_INTERVAL_ARRAY @"TimerIntervalArray"
#define DEFAULT_INTERVAL_ARRAY @[@15,@0,@0,@0,@0]
#define MAX_TIMER_LENGTH 91
#define NUMBER_OF_CHIMES @"NumberOfChimes"

@interface SettingsTableViewController () <RefreshIntervalCellDelegate>

@property (nonatomic, strong) IntervalCell *intervalCell;
@property (nonatomic, strong) ChimeSelectorCell *soundSelectorCell;
@property (nonatomic, strong) SelectorCell *backgroundSelectorCell;
@property (nonatomic, strong) StartCell *startCell;
@property (nonatomic, strong) RequestPermissionsCell *requestPermissionsCell;

@property (nonatomic, strong) IntervalCellDelegateAndDataSource *intervalCellDelegateAndDataSource;
@property (nonatomic, strong) NSArray *intervalArray;
@property (nonatomic) BOOL displayIntervals;

@property (nonatomic) NSInteger selectedSoundIndex;
@property (nonatomic, strong) NSArray *soundNamesArray;

@property (nonatomic) NSInteger selectedBackgroundIndex;
@property (nonatomic, strong) NSArray *backgroundNamesArray;

@property (nonatomic) BOOL productsLoaded;
@property (nonatomic, strong) Purchaser *purchaser;
@property (nonatomic) BOOL productsPurchased;

@end

@implementation SettingsTableViewController

@synthesize displayIntervals = _displayIntervals;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self requestIAPProducts];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    self.tableView.estimatedRowHeight = 80;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playSound:) name:@"PlaySound" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCells) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSettingsDidChange:) name:@"NOTIFICATION_SETTINGS_DID_CHANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCells) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GoogleAnalyticsHelper logScreenNamed:@"Settings Screen"];
}

-(void)refreshCells
{
    [self.intervalCell refreshWithIntervalArray:self.intervalArray selectedButtonIndex:0 intervalsAllowed:self.productsPurchased];
    [self.soundSelectorCell refreshWithSelectedButtonIndex:self.selectedSoundIndex itemsPurchased:self.productsPurchased];
    [self.backgroundSelectorCell refreshWithSelectedButtonIndex:self.selectedBackgroundIndex itemsPurchased:self.productsPurchased];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & Setters

-(IntervalCell *)intervalCell
{
    if(!_intervalCell){
        if(self.displayIntervals){
            _intervalCell = [[[NSBundle mainBundle] loadNibNamed:@"IntervalCell" owner:self options:nil] firstObject];
        } else {
            _intervalCell = [[[NSBundle mainBundle] loadNibNamed:@"SingleIntervalCell" owner:self options:nil] firstObject];
        }
        [_intervalCell setupIntervalCellWithDelegate:self.intervalCellDelegateAndDataSource dataSource:self.intervalCellDelegateAndDataSource intervalArray:self.intervalArray intervalsAllowed:self.productsPurchased];
        [_intervalCell.resetButton addTarget:self action:@selector(resetIntervals:) forControlEvents:UIControlEventTouchUpInside];
        [_intervalCell.toggleIntervalsButton addTarget:self action:@selector(toggleIntervals:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _intervalCell;
}

-(IntervalCellDelegateAndDataSource *)intervalCellDelegateAndDataSource
{
    if(!_intervalCellDelegateAndDataSource){
        _intervalCellDelegateAndDataSource = [[IntervalCellDelegateAndDataSource alloc] initWithIntervalButtonArray:_intervalCell.buttonArray andPickerViewContainingRows:MAX_TIMER_LENGTH];
        _intervalCellDelegateAndDataSource.delegate = self;
    }
    return _intervalCellDelegateAndDataSource;
}

-(BOOL)displayIntervals
{
    if(!_displayIntervals){
        _displayIntervals = [[NSUserDefaults standardUserDefaults] boolForKey:DISPLAY_INTERVALS];
    }
    return _displayIntervals;
}

-(void)setDisplayIntervals:(BOOL)displayIntervals
{
    _displayIntervals = displayIntervals;
    
    [[NSUserDefaults standardUserDefaults] setBool:displayIntervals forKey:DISPLAY_INTERVALS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray *)intervalArray
{
    _intervalArray = [[NSUserDefaults standardUserDefaults] arrayForKey:TIMER_INTERVAL_ARRAY];
    
    if(!_intervalArray){
        _intervalArray = DEFAULT_INTERVAL_ARRAY;
        [[NSUserDefaults standardUserDefaults] setObject:_intervalArray forKey:TIMER_INTERVAL_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _intervalArray;
}

-(ChimeSelectorCell *)soundSelectorCell
{
    if(!_soundSelectorCell){
        _soundSelectorCell = [[[NSBundle mainBundle] loadNibNamed:@"ChimeSelectorCell" owner:self options:nil] firstObject];
        [_soundSelectorCell setupWithSelectedButtonIndex:[[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_SOUND_INDEX]  numberOfFreeSelections:2 itemsPurchased:self.productsPurchased];
        _soundSelectorCell.numberOfTimesSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:NUMBER_OF_CHIMES];
        [_soundSelectorCell.numberOfTimesSegmentedControl addTarget:self action:@selector(changeNumberOfChimes) forControlEvents:UIControlEventValueChanged];
    }
    return _soundSelectorCell;
}


-(NSArray *)soundNamesArray
{
    return @[UILocalNotificationDefaultSoundName, @"tingsha", @"gong", @"bell", @"bowl"];
}

-(SelectorCell *)backgroundSelectorCell
{
    if(!_backgroundSelectorCell){
        _backgroundSelectorCell = [[[NSBundle mainBundle] loadNibNamed:@"SelectorCell" owner:self options:nil] firstObject];
        [_backgroundSelectorCell setupWithSelectedButtonIndex:[[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_BACKGROUND_INDEX]  numberOfFreeSelections:2 itemsPurchased:self.productsPurchased];
    }
    return _backgroundSelectorCell;
}

-(NSArray *)backgroundNamesArray
{
    return @[@"flowers_yellow", @"flowers_pink", @"flowers_dark", @"flowers_blue", @"trees_one"];
}

-(NSInteger)selectedBackgroundIndex
{
    if(!_selectedBackgroundIndex){
        _selectedBackgroundIndex = [[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_BACKGROUND_INDEX];
    }
    return _selectedBackgroundIndex;
}

-(StartCell *)startCell
{
    if(!_startCell){
        _startCell = [[[NSBundle mainBundle] loadNibNamed:@"StartCell" owner:self options:nil] firstObject];
        [_startCell.startButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startCell;
}

-(RequestPermissionsCell *)requestPermissionsCell
{
    if(!_requestPermissionsCell){
        _requestPermissionsCell = [[[NSBundle mainBundle] loadNibNamed:@"RequestPermissionsCell" owner:self options:nil] firstObject];
        [_requestPermissionsCell.action addTarget:self action:@selector(requestNotificationPermissions:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestPermissionsCell;
}

-(Purchaser *)purchaser
{
    if(!_purchaser){
        _purchaser = [[Purchaser alloc] init];
    }
    return _purchaser;
}

-(BOOL)productsPurchased
{
    return [[MindTimerIAPHelper sharedInstance] productPurchased:ALL_FEATURES_PRODUCT];
}

-(NSInteger)selectedSoundIndex
{
    if(!_selectedSoundIndex){
        _selectedSoundIndex = [[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_SOUND_INDEX];
    }
    return _selectedSoundIndex;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            if([self hasNecessaryNotificationPermissions]){
                cell = self.startCell;
            } else {
                cell = self.requestPermissionsCell;
            }
            break;
            
        case 1:
            cell = self.intervalCell;
            for(UIButton *button in self.intervalCell.buttonArray){
                [button addTarget:self action:@selector(intervalSelected:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
            
        case 2:
            cell = self.soundSelectorCell;
            for(UIButton *button in self.soundSelectorCell.buttonArray){
                [button addTarget:self action:@selector(soundSelected:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
            
        case 3:
            cell = self.backgroundSelectorCell;
            for(UIButton *button in self.backgroundSelectorCell.buttonArray){
                [button addTarget:self action:@selector(backgroundSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [button setImage:[UIImage imageNamed:self.backgroundNamesArray[button.tag]] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    NSString *title;
    switch (section) {
        case 1:
            if(self.displayIntervals){
                title = @"Interval Duration";
            } else {
                title = @"Duration";
            }
            break;
        case 2:
            title = @"Chime";
            break;
        case 3:
            title = @"Background";
            break;
            
        default:
            break;
    }
    if(section > 0){
        headerView.textLabel.text = [title uppercaseString];
    }
    return headerView;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4) {
        return UITableViewAutomaticDimension;
    }
    
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            if([self hasNecessaryNotificationPermissions]){
                cell = self.startCell;
            } else {
                cell = self.requestPermissionsCell;
            }
            break;
        case 1:
            cell = self.intervalCell;
            break;
        case 2:
            cell = self.soundSelectorCell;
            break;
        case 3:
            cell = self.backgroundSelectorCell;
            break;
            
        default:
            break;
    }
    
    return [cell.contentView sizeThatFits:UILayoutFittingCompressedSize].height+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section > 0){
        return 50;
    } else {
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.attributedText = [[NSAttributedString alloc] initWithString:headerView.textLabel.text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
}


#pragma mark - Navigation

-(void)startTimer
{
    [self performSegueWithIdentifier:@"Timer Segue" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Timer Segue"]){
        TimerViewController *timerViewController = (TimerViewController *)segue.destinationViewController;
        
        NSArray *intervalArray = self.intervalArray;
        if(!self.displayIntervals){
            intervalArray = @[self.intervalArray[0]];
        }
        
        [timerViewController setTimerIntervalArray:intervalArray withSoundEffect:self.soundNamesArray[self.selectedSoundIndex] numberOfChimes:self.soundSelectorCell.numberOfTimesSegmentedControl.selectedSegmentIndex+1 andBackground:self.backgroundNamesArray[self.selectedBackgroundIndex]];
    }
}





#pragma mark - Target Action

-(IBAction)intervalSelected:(UIButton *)sender
{
    [self.intervalCell refreshWithIntervalArray:self.intervalArray selectedButtonIndex:sender.tag intervalsAllowed:self.productsPurchased];
}

-(IBAction)resetIntervals:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_INTERVAL_ARRAY forKey:TIMER_INTERVAL_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.intervalCell refreshWithIntervalArray:self.intervalArray selectedButtonIndex:0 intervalsAllowed:self.productsPurchased];
}

-(IBAction)soundSelected:(UIButton *)sender
{
    BOOL allFeaturesAvailable = self.productsPurchased;
    
    NSString *soundEffectName = self.soundNamesArray[sender.tag];
    if(sender.tag < 2 || allFeaturesAvailable){
        
        [self.soundSelectorCell refreshWithSelectedButtonIndex:sender.tag itemsPurchased:allFeaturesAvailable];
        self.selectedSoundIndex = sender.tag;
        
        [self playSoundNamed:soundEffectName];
        
        [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:SELECTED_SOUND_INDEX];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"not purchased yet");
        [self showPurchaseAlertForProduct:soundEffectName withSoundEffect:YES];
    }
}

-(void)showPurchaseAlertForProduct:(NSString *)productName withSoundEffect:(BOOL)soundEffect
{
    if(!self.productsLoaded){
        [self requestIAPProducts];
    }
    
    NSString *soundEffectName;
    
    if(soundEffect){
        soundEffectName = productName;
        productName = [NSString stringWithFormat:@"the %@ chime",[productName capitalizedString]];
    }
    
    UIActionSheet *actionSheet = [self.purchaser actionSheetForProduct:productName withSoundPreview:soundEffectName andProductsLoaded:self.productsLoaded];
    [actionSheet showInView:self.view];
}

-(void)playSound:(NSNotification *)notification
{
    [self playSoundNamed:notification.object];
}

-(void)playSoundNamed:(NSString *)soundName
{
    NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"aif"];
    SoundEffectPlayer *player = [[SoundEffectPlayer alloc] initWithURL:soundEffectURL];
    [player playSoundOrVibrate:NO];
}

-(IBAction)backgroundSelected:(UIButton *)sender
{
    BOOL allFeaturesAvailable = self.productsPurchased;
    
    if(sender.tag < 2 || allFeaturesAvailable){
        [self.backgroundSelectorCell refreshWithSelectedButtonIndex:sender.tag itemsPurchased:allFeaturesAvailable];
        self.selectedBackgroundIndex = sender.tag;
        
        [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:SELECTED_BACKGROUND_INDEX];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self showPurchaseAlertForProduct:@"this background" withSoundEffect:NO];
    }
}

-(IBAction)toggleIntervals:(UIButton *)sender
{
    if(self.productsPurchased){
        self.displayIntervals = !self.displayIntervals;
        [self resetIntervalCell];
        
    } else {
        NSLog(@"not purchased yet");
        [self showPurchaseAlertForProduct:@"Meditation Intervals" withSoundEffect:NO];
    }
}

-(void)resetIntervalCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.intervalCell];
    self.intervalCell = nil;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)changeNumberOfChimes
{
    NSLog(@"%ld",(long)self.soundSelectorCell.numberOfTimesSegmentedControl.selectedSegmentIndex);
    [[NSUserDefaults standardUserDefaults] setInteger:self.soundSelectorCell.numberOfTimesSegmentedControl.selectedSegmentIndex forKey:NUMBER_OF_CHIMES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - RefreshIntervalCellDelegate

-(void)refreshIntervalCell
{
    NSInteger intervalIndex = [self selectedIntervalIndex];
    [self.intervalCell refreshWithIntervalArray:self.intervalArray selectedButtonIndex:intervalIndex intervalsAllowed:self.productsPurchased];
}

-(NSInteger)selectedIntervalIndex
{
    NSInteger selectedIntervalIndex = 0;
    
    for(UIButton *button in self.intervalCell.buttonArray){
        if(button.selected == YES){
            selectedIntervalIndex = button.tag;
            break;
        }
    }
    
    return selectedIntervalIndex;
}

#pragma mark - Unwind Segue

-(IBAction)returningFromTimer:(UIStoryboardSegue *)segue
{
    NSLog(@"end");
}


#pragma mark - IAP

-(void)requestIAPProducts
{
    [[MindTimerIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            // allow IAPs to proceed
            NSLog(@"requestProductsWithCompletionHandler says SUCCESS!");
            self.productsLoaded = YES;
        } else {
            self.productsLoaded = NO;
            NSLog(@"requestProductsWithCompletionHandler says Failure!");
        }
    }];
}



#pragma mark - Notification permissions

-(BOOL)hasNecessaryNotificationPermissions
{
    BOOL hasPermissions = NO;
    BOOL needsPermissions = [[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)];
    if (needsPermissions){
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (grantedSettings.types & UIUserNotificationTypeSound){
            hasPermissions = YES;
        }
        
    } else {
        hasPermissions = YES;
    }
    
    return hasPermissions;
}

-(IBAction)requestNotificationPermissions:(id)sender
{
    BOOL needsPermissions = [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)];
    
    if (needsPermissions){
        UIUserNotificationType types = UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

-(void)notificationSettingsDidChange:(NSNotification *)notification
{
    UIUserNotificationSettings *notificationSettings = (UIUserNotificationSettings *)notification.object;
    
    if(notificationSettings.types == UIUserNotificationTypeNone){
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notifications Disabled" message:@"In order to use Mind Timer, please open this app's settings and allow sound notifications." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                if (canOpenSettings) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:defaultAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:^{}];
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning...");
}







@end
