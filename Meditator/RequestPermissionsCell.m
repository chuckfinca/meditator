//
//  RequestPermissionsCell.m
//  mindtimer
//
//  Created by Charles Feinn on 2/17/16.
//  Copyright © 2016 AppSimple. All rights reserved.
//

#import "RequestPermissionsCell.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface RequestPermissionsCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RequestPermissionsCell

- (void)awakeFromNib {
    // Initialization code
    NSAttributedString *actionAttributes = [[NSAttributedString alloc] initWithString:@"Enable Notifications" attributes:[FontThemer sharedInstance].whiteHeadlineTextAttributes];
    [self.action setAttributedTitle:actionAttributes forState: UIControlStateNormal];
    
    self.action.backgroundColor = [ColorSchemer sharedInstance].clickable;
    
    NSAttributedString *labelAttributes = [[NSAttributedString alloc] initWithString:@"Mind Timer needs permission to notify you when your meditation completes." attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    self.label.attributedText = labelAttributes;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
