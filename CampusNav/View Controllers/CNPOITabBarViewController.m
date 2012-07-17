//
//  CNPOITabBarViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPOITabBarViewController.h"
#import "GGFloorPlanPool.h"
#import "GGPOIPool.h"
#import "CNCategoryTableViewController.h"

@interface CNPOITabBarViewController ()
@property (nonatomic, strong) GGFloorPlanPool *floorPlanPool;

@end

@implementation CNPOITabBarViewController

#pragma mark - getter & setter
@synthesize floorPlanPool = _floorPlanPool;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.delegate = self;
	self.floorPlanPool = [GGFloorPlanPool floorPlanPoolOfBuilding:@"Mathmetics & Computer"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Tab Bar Controller Delegate

- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[CNCategoryTableViewController class]]) {
		CNCategoryTableViewController *categoryVC = (CNCategoryTableViewController *) viewController;
		GGPOIPool *poiPool = [GGPOIPool poiPoolOfFloorPlan:[self.floorPlanPool.floorPlans objectAtIndex:0]];
		categoryVC.poiPool = poiPool;
	}
}

@end
