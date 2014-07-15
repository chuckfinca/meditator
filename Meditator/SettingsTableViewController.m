//
//  SettingsTableViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MinutePickerViewCell.h"
#import "SoundSelectorCell.h"
#import "TimerViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) MinutePickerViewCell *minutePickerViewCell;
@property (nonatomic, strong) SoundSelectorCell *soundSelectorCell;

@property (nonatomic) NSInteger selectedSoundNumber;

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

-(SoundSelectorCell *)soundSelectorCell
{
    if(!_soundSelectorCell){
        _soundSelectorCell = [[[NSBundle mainBundle] loadNibNamed:@"SoundSelectorCell" owner:self options:nil] firstObject];
    }
    return _soundSelectorCell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
            title = @"Meditation length";
            break;
        case 1:
            title = @"Completion sound";
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
        
        [timerViewController setTimerWithSound:@"bell" extension:@"aif" andDuration:minutes];
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
    self.selectedSoundNumber = sender.tag;
    NSLog(@"tag = %ld",(long)sender.tag);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning...");
}







@end
