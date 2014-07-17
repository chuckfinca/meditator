//
//  IntervalCell.h
//  Meditator
//
//  Created by Charles Feinn on 7/16/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INTERVAL_CELL_REUSE_IDENTIFIER @"IntervalCell"

@interface IntervalCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleIntervalsButton;

-(void)refreshWithIntervalArray:(NSArray *)intervalsArray andSelectedButtonIndex:(NSInteger)selectedButtonIndex;

@end
