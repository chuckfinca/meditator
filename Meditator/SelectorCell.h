//
//  SoundSelectorCell.h
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SOUND_SELECTOR_CELL_REUSE_IDENTIFIER @"SoundSelectorCell"

@interface SelectorCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

-(void)setupWithSelectedButtonIndex:(NSInteger)selectedButtonIndex numberOfFreeSelections:(NSInteger)numberOfFreeSelections itemsPurchased:(BOOL)itemsPurchased;
-(void)refreshWithSelectedButtonIndex:(NSInteger)selectedButtonIndex itemsPurchased:(BOOL)itemsPurchased;

@end
