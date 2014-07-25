//
//  AppCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppCell.h"
@interface AppCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToBottomConstraint;
@end


@implementation AppCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setupWithAppIconImageName:(NSString *)imageName name:(NSString *)appName
{
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    self.appNameLabel.text = appName;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}











@end
