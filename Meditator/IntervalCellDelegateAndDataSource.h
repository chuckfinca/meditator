//
//  IntervalDelegateAndDataSource.h
//  Meditator
//
//  Created by Charles Feinn on 7/16/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshIntervalCellDelegate

-(void)refreshIntervalCell;
-(NSInteger)selectedIntervalIndex;

@end


@interface IntervalCellDelegateAndDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id <RefreshIntervalCellDelegate> delegate;

-(id)initWithIntervalButtonArray:(NSArray *)buttonArray andPickerViewContainingRows:(NSInteger)numberOfRows;

@end
