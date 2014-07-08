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

@interface SettingsTableViewController ()


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
    [self.tableView registerNib:[UINib nibWithNibName:@"MinutePickerViewCell" bundle:nil] forCellReuseIdentifier:MINUTE_PICKER_VIEW_CELL_REUSE_IDENTIFIER];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SoundSelectorCell" bundle:nil] forCellReuseIdentifier:SOUND_SELECTOR_CELL_REUSE_IDENTIFIER];
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
            cell = [tableView dequeueReusableCellWithIdentifier:MINUTE_PICKER_VIEW_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:SOUND_SELECTOR_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
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
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MinutePickerViewCell" owner:self options:nil] firstObject];
            break;
        case 1:
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundSelectorCell" owner:self options:nil] firstObject];
            break;
            
        default:
            break;
    }
    return cell.bounds.size.height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SettingsTableViewController didReceiveMemoryWarning");
}







@end
