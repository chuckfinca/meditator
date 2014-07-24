//
//  AppCell.h
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCell : UITableViewCell

@property (nonatomic) NSInteger appID;

-(void)setupWithAppImageName:(NSString *)imageName name:(NSString *)appName andAppID:(NSInteger)appID;

@end
