//
//  AppCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppCell.h"
#import "FontThemer.h"

@interface AppCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToImageViewConstraint;
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
    self.appNameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.appNameLabel.text attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
}











@end
