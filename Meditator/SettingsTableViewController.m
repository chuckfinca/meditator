//
//  SettingsTableViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MinutePickerViewCell.h"
#import "SelectorCell.h"
#import "TimerViewController.h"

#define SELECTED_SOUND_INDEX @"SelectedSoundIndex"
#define SELECTED_BACKGROUND_INDEX @"SelectedBackgroundIndex"

@interface SettingsTableViewController ()

@property (nonatomic, strong) MinutePickerViewCell *minutePickerViewCell;
@property (nonatomic, strong) SelectorCell *soundSelectorCell;
@property (nonatomic, strong) SelectorCell *backgroundSelectorCell;

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

-(MinutePickerViewCell *)minutePickerViewCell
{
    if(!_minutePickerViewCell){
        _minutePickerViewCell = [[[NSBundle mainBundle] loadNibNamed:@"MinutePickerViewCell" owner:self options:nil] firstObject];
    }
    return _minutePickerViewCell;
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
            cell = self.minutePickerViewCell;
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
            title = @"meditation length";
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
            cell = self.minutePickerViewCell;
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
        NSInteger minutes = [self.minutePickerViewCell.minutesPickerView selectedRowInComponent:0] + 1;
        
        [timerViewController setTimerWithDuration:minutes completionSound:self.soundNamesArray[self.selectedSoundIndex] andBackground:self.backgroundNamesArray[self.selectedBackgroundIndex]];
    }
}


#pragma mark - Unwind Segue

-(IBAction)returningFromTimer:(UIStoryboardSegue *)segue
{
    NSLog(@"end");
}


#pragma mark - Target Action

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning...");
}







@end
