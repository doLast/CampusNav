//
//  CNUICustomize.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNUICustomize.h"

#import <QuartzCore/QuartzCore.h>

@implementation CNUICustomize

#pragma mark - Theme Customize

+ (void)customizeTheme
{
    [[UIApplication sharedApplication] 
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [UIImage imageNamed:@"menubar.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal 
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal 
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-active.png"]];
	
	UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
	[[UITableView appearance] setBackgroundColor:bgColor];
	
}

+ (void)configureTabBar:(UITabBarController *)tabBarController
{	
    UIViewController *controller1 = [[tabBarController viewControllers] objectAtIndex:0];
    [CNUICustomize configureTabBarItemWithImageName:@"tab-icon4.png" andText:@"Favorites" forViewController:controller1];
    
    
    UIViewController *controller2 = [[tabBarController viewControllers] objectAtIndex:1];
    [CNUICustomize configureTabBarItemWithImageName:@"tab-icon2.png" andText:@"Browse" forViewController:controller2];
    
    
    UIViewController *controller3 = [[tabBarController viewControllers] objectAtIndex:2];
    [CNUICustomize configureTabBarItemWithImageName:@"tab-icon3.png" andText:@"Navigation" forViewController:controller3];
    
    
//    UIViewController *controller4 = [[tabBarController viewControllers] objectAtIndex:3];
//    [CNUICustomize configureTabBarItemWithImageName:@"tab-icon4.png" andText:@"Other" forViewController:controller4];
    
}

+ (void)configureTabBarItemWithImageName:(NSString*)imageName 
								andText:(NSString *)itemText 
					  forViewController:(UIViewController *)viewController
{
    UIImage* icon1 = [UIImage imageNamed:imageName];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:itemText image:icon1 tag:0];
    [item1 setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
    
    [viewController setTabBarItem:item1];
}

#pragma mark - View Customize

+ (void)dropShadowForView:(UIView *)view
{
	CALayer* shadowLayer = [self createShadowWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 5)];
	
	[view.layer addSublayer:shadowLayer];
	view.clipsToBounds = NO;
}

+ (void)dropShadowFromCeilingForView:(UIView *)view
{
	CALayer* shadowLayer = [self createShadowWithFrame:CGRectMake(0, 0, view.frame.size.width, 5)];
	
	[view.layer addSublayer:shadowLayer];
	view.clipsToBounds = NO;
}

+ (void)customizeViewController:(UIViewController *)viewController
{
//	UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
//	viewController.view.backgroundColor = bgColor;
}

+ (CALayer *)createShadowWithFrame:(CGRect)frame
{
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = frame;
	
	UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
	UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	
	gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
	
	return gradient;
}

@end
