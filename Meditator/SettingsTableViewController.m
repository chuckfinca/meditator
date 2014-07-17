//
//  SettingsTableViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "IntervalCell.h"
#import "SelectorCell.h"
#import "TimerViewController.h"
#import "IntervalCellDelegateAndDataSource.h"

#define SELECTED_SOUND_INDEX @"SelectedSoundIndex"
#define SELECTED_BACKGROUND_INDEX @"SelectedBackgroundIndex"
#define TIMER_INTERVAL_ARRAY @"TimerIntervalArray"

@interface SettingsTableViewController () <RefreshIntervalCellDelegate>

@property (nonatomic, strong) IntervalCell *intervalCell;
@property (nonatomic, strong) SelectorCell *soundSelectorCell;
@property (nonatomic, strong) SelectorCell *backgroundSelectorCell;

@property (nonatomic, strong) IntervalCellDelegateAndDataSource *intervalCellDelegateAndDataSource;
@property (nonatomic, strong) NSArray *intervalArray;
@property (nonatomic) BOOL displayIntervals;

@property (nonatomic) NSInteger selectedSoundIndex;
@property (nonatomic, strong) NSArray *soundNamesArray;

@property (nonatomic) NSInteger selectedBackgroundIndex;
@property (nonatomic, strong) NSArray *backgroundNamesArray;

@end

@implementation SettingsTableViewController

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
        _intervalCellDelegateAndDataSource = [[IntervalCellDelegateAndDataSource alloc] initWithIntervalButtonArray:_intervalCell.buttonArray andPickerViewContainingRows:90];
        _intervalCellDelegateAndDataSource.delegate = self;
    }
    return _intervalCellDelegateAndDataSource;
}

-(NSArray *)intervalArray
{
    _intervalArray = [[NSUserDefaults standardUserDefaults] arrayForKey:TIMER_INTERVAL_ARRAY];
    
    if(!_intervalArray){
        _intervalArray = @[@14,@0,@0,@0,@0];
        [[NSUserDefaults standardUserDefaults] setObject:_intervalArray forKey:TIMER_INTERVAL_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _intervalArray;
}

-(SelectorCell *)soundSelectorCell
{
    if(!_soundSelectorCell){
        _soundSelectorCell = [[[NSBundle mainBundle] loadNibNamed:@"SelectorCell" owner:self options:nil] firstObject];
        [_soundSelectorCell refreshWithSelectedButtonIndex:[[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_SOUND_INDEX]];
    }
    return _soundSelectorCell;
}

-(NSArray *)soundNamesArray
{
    return @[UILocalNotificationDefaultSoundName, @"bell", @"drum", @"bell", @"bell"];
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
    return @[@"blue", @"flowers", @"blue", @"bell", @"bell"];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            cell = self.intervalCell;
            for(UIButton *button in self.intervalCell.buttonArray){
                [button addTarget:self action:@selector(intervalSelected:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
            
        case 1:
            cell = self.soundSelectorCell;
            for(UIButton *button in self.soundSelectorCell.buttonArray){
                [button addTarget:self action:@selector(soundSelected:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
            
        case 2:
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = @"interval length";
            break;
        case 1:
            title = @"completion sound";
            break;
        case 2:
            title = @"timer background";
            break;
            
        default:
            break;
    }
    return title;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = self.intervalCell;
            break;
        case 1:
            cell = self.soundSelectorCell;
            break;
        case 2:
            cell = self.backgroundSelectorCell;
            break;
            
        default:
            break;
    }
    return cell.bounds.size.height;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Timer Segue"]){
        TimerViewController *timerViewController = (TimerViewController *)segue.destinationViewController;
        NSInteger minutes = [self.intervalCell.minutePickerView selectedRowInComponent:0] + 1;
        
        [timerViewController setTimerWithDuration:minutes completionSound:self.soundNamesArray[self.selectedSoundIndex] andBackground:self.backgroundNamesArray[self.selectedBackgroundIndex]];
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
    [[NSUserDefaults standardUserDefaults] setObject:@[@14,@0,@0,@0,@0] forKey:TIMER_INTERVAL_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNumber *minutes = (NSNumber *)self.intervalArray[0];
    [self.intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:0];
    [self.intervalCell.minutePickerView selectRow:[minutes integerValue] inComponent:0 animated:YES];
}

-(IBAction)soundSelected:(UIButton *)sender
{
    [self.soundSelectorCell refreshWithSelectedButtonIndex:sender.tag];
    self.selectedSoundIndex = sender.tag;
    
    [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:SELECTED_SOUND_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)backgroundSelected:(UIButton *)sender
{
    [self.backgroundSelectorCell refreshWithSelectedButtonIndex:sender.tag];
    self.selectedBackgroundIndex = sender.tag;
    
    [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:SELECTED_BACKGROUND_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)toggleIntervals:(UIButton *)sender
{
    self.displayIntervals = !self.displayIntervals;
    self.intervalCell = nil;
    [self.tableView reloadData];
}


#pragma mark - RefreshIntervalCellDelegate

-(void)refreshIntervalCell
{
    [self.intervalCell refreshWithIntervalArray:self.intervalArray andSelectedButtonIndex:[self selectedIntervalIndex]];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning...");
}







@end
