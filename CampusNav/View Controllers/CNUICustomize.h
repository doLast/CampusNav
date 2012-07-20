//
//  CNUICustomize.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface CNUICustomize : NSObject

+ (void)customizeTheme;
+ (void)configureTabBar:(UITabBarController *)tabBarController;

+ (void)dropShadowForView:(UIView *)view;
+ (void)customizeViewController:(UIViewController *)viewController;

@end
