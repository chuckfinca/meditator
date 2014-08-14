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

#define SELECTED_SOUND_INDEX @"SelectedSoundIndex"
#define SELECTED_BACKGROUND_INDEX @"SelectedBackgroundIndex"
#define DISPLAY_INTERVALS @"DisplayIntervals"
#define TIMER_INTERVAL_ARRAY @"TimerIntervalArray"
#define DEFAULT_INTERVAL_ARRAY @[@15,@0,@0,@0,@0]
#define MAX_TIMER_LENGTH 91

@interface SettingsTableViewController () <RefreshIntervalCellDelegate>

@property (nonatomic, strong) IntervalCell *intervalCell;
@property (nonatomic, strong) ChimeSelectorCell *soundSelectorCell;
@property (nonatomic, strong) SelectorCell *backgroundSelectorCell;
@property (nonatomic, strong) StartCell *startCell;

@property (nonatomic, strong) IntervalCellDelegateAndDataSource *intervalCellDelegateAndDataSource;
@property (nonatomic, strong) NSArray *intervalArray;
@property (nonatomic) BOOL displayIntervals;

@property (nonatomic) NSInteger selectedSoundIndex;
@property (nonatomic, strong) NSArray *soundNamesArray;

@property (nonatomic) NSInteger selectedBackgroundIndex;
@property (nonatomic, strong) NSArray *backgroundNamesArray;

@property (nonatomic) BOOL productsLoaded;
@property (nonatomic, strong) Purchaser *purchaser;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GoogleAnalyticsHelper logScreenNamed:@"Settings Screen"];
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
        _intervalCell.minutePickerView.delegate = self.intervalCellDelegateAndDataSource;
        _intervalCell.minutePickerView.dataSource = self.intervalCellDelegateAndDataSource;
        [_intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:0];
        [_intervalCell.resetButton addTarget:self action:@selector(resetIntervals:) forControlEvents:UIControlEventTouchUpInside];
        [_intervalCell.toggleIntervalsButton addTarget:self action:@selector(toggleIntervals:) forControlEvents:UIControlEventTouchUpInside];
        
        NSNumber *minutes = self.intervalArray[0];
        [_intervalCell.minutePickerView selectRow:[minutes integerValue] inComponent:0 animated:NO];
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
        [_soundSelectorCell refreshWithSelectedButtonIndex:[[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_SOUND_INDEX]];
        
        for(UIButton *button in _soundSelectorCell.buttonArray){
            if(button.tag == 0){
                [button setImage:[[UIImage imageNamed:@"vibrate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else if(button.tag == 1){
                [button setImage:[[UIImage imageNamed:@"tingshas"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else if(button.tag == 2){
                [button setImage:[[UIImage imageNamed:@"gong"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else if(button.tag == 3){
                [button setImage:[[UIImage imageNamed:@"bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else {
                [button setImage:[[UIImage imageNamed:@"bowl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
        }
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
        [_backgroundSelectorCell refreshWithSelectedButtonIndex:[[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_BACKGROUND_INDEX]];
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

-(Purchaser *)purchaser
{
    if(!_purchaser){
        _purchaser = [[Purchaser alloc] init];
    }
    return _purchaser;
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
            cell = self.startCell;
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
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = self.startCell;
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
    return cell.bounds.size.height;
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
    NSNumber *minutes = (NSNumber *)self.intervalArray[sender.tag];
    
    [self.intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:sender.tag];
    [self.intervalCell.minutePickerView selectRow:[minutes integerValue] inComponent:0 animated:YES];
}

-(IBAction)resetIntervals:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_INTERVAL_ARRAY forKey:TIMER_INTERVAL_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNumber *minutes = (NSNumber *)self.intervalArray[0];
    [self.intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:0];
    [self.intervalCell.minutePickerView selectRow:[minutes integerValue] inComponent:0 animated:YES];
}

-(IBAction)soundSelected:(UIButton *)sender
{
    NSString *soundEffectName = self.soundNamesArray[sender.tag];
    if(sender.tag < 2 || [[MindTimerIAPHelper sharedInstance] productPurchased:ALL_FEATURES_PRODUCT]){
        
        [self.soundSelectorCell refreshWithSelectedButtonIndex:sender.tag];
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
        productName = [NSString stringWithFormat:@"the %@ chime",[productName capitalizedString]];
        soundEffectName = productName;
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
    if(sender.tag < 2 || [[MindTimerIAPHelper sharedInstance] productPurchased:ALL_FEATURES_PRODUCT]){
        [self.backgroundSelectorCell refreshWithSelectedButtonIndex:sender.tag];
        self.selectedBackgroundIndex = sender.tag;
        
        [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:SELECTED_BACKGROUND_INDEX];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self showPurchaseAlertForProduct:@"this background" withSoundEffect:NO];
    }
}

-(IBAction)toggleIntervals:(UIButton *)sender
{
    if([[MindTimerIAPHelper sharedInstance] productPurchased:ALL_FEATURES_PRODUCT]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.intervalCell];
        self.displayIntervals = !self.displayIntervals;
        self.intervalCell = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSLog(@"not purchased yet");
        [self showPurchaseAlertForProduct:@"Meditation Intervals" withSoundEffect:NO];
    }
}


#pragma mark - RefreshIntervalCellDelegate

-(void)refreshIntervalCell
{
    NSInteger intervalIndex = [self selectedIntervalIndex];
    [self.intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:intervalIndex];
    
    NSNumber *minutes = self.intervalArray[intervalIndex];
    [self.intervalCell.minutePickerView selectRow:[minutes integerValue] inComponent:0 animated:YES];
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning...");
}







@end
