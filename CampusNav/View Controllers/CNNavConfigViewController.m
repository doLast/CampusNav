//
//  CNNavConfigViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavConfigViewController.h"
#import "CNPOICell.h"
#import "CNUICustomize.h"

NSString * const kCNNavConfigNotification = @"CNNavConfigNotification";
NSString * const kCNNavConfigNotificationType = @"CNNavConfigNotificationType";
NSString * const kCNNavConfigNotificationData = @"CNNavConfigNotificationData";

NSString * const kCNNavConfigTypeSource = @"CNNavConfigTypeSource";
NSString * const kCNNavConfigTypeDestination = @"CNNavConfigTypeDestination";

@interface CNNavConfigViewController ()

@end

@implementation CNNavConfigViewController

#pragma mark - Getter & Setter
@synthesize sourcePOI = _sourcePOI;
@synthesize destinationPOI = _destinationPOI;

@synthesize navSourceCell = _navSourceCell;
@synthesize navDestinationCell = _navDestinationCell;
@synthesize startNavCell = _startNavCell;

#pragma mark - View controller events

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavConfigNotification:) name:kCNNavConfigNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CNUICustomize customizeViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.sourcePOI != nil) {
		[self.navSourceCell fillCellWithPOI:self.sourcePOI];
	}
	if (self.destinationPOI != nil) {
		[self.navDestinationCell fillCellWithPOI:self.destinationPOI];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleNavConfigNotification:(NSNotification *)notification
{
	NSDictionary *info = notification.userInfo;
	NSString *type = [info objectForKey:kCNNavConfigNotificationType];
	GGPOI *poi = [info objectForKey:kCNNavConfigNotificationData];
	
	if (type == kCNNavConfigTypeSource) {
		self.sourcePOI = poi;
	}
	else if (type == kCNNavConfigTypeDestination) {
		self.destinationPOI = poi;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	self.tabBarController.selectedViewController = self.navigationController;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
