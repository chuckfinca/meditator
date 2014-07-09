//
//  BlurredImageCreator.m
//  Meditator
//
//  Created by Charles Feinn on 7/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "BlurredImageCreator.h"

@implementation BlurredImageCreator

-(UIImage *)createImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}






@end
