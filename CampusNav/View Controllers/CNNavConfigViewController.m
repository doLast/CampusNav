//
//  CNNavConfigViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavConfigViewController.h"
#import "CNNavResultViewController.h"

#import "CNPOICell.h"
#import "CNUICustomize.h"

#import "GGSystem.h"
#import "CNPathCalculator.h"
#import "CNSameFloorPathCalculator.h"
#import "CNSameBuildingPathCalculator.h"

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
	
	// Subscribe to kCNNavConfigNotification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavConfigNotification:) name:kCNNavConfigNotification object:nil];
	
	self.sourcePOI = nil;
	self.destinationPOI = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CNUICustomize customizeViewController:self];
	
	// Disable start at the beginning
	self.startNavCell.userInteractionEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateNavCells];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateNavCells
{
	[self.navSourceCell fillCellWithPOI:self.sourcePOI];
	[self.navDestinationCell fillCellWithPOI:self.destinationPOI];
}

- (void)handleNavConfigNotification:(NSNotification *)notification
{
	// Obtain the informations
	NSDictionary *info = notification.userInfo;
	NSString *type = [info objectForKey:kCNNavConfigNotificationType];
	GGPOI *poi = [info objectForKey:kCNNavConfigNotificationData];
	
	// Save the poi as source or destination
	if (type == kCNNavConfigTypeSource) {
		self.sourcePOI = poi;
	}
	else if (type == kCNNavConfigTypeDestination) {
		self.destinationPOI = poi;
	}
	
	// Prompt itself to the front
	[self.navigationController popToRootViewControllerAnimated:YES];
	self.tabBarController.selectedViewController = self.navigationController;
	
	// Enable the start if both source and destination is set
	if (self.sourcePOI != nil && self.destinationPOI != nil) {
		self.startNavCell.userInteractionEnabled = YES;
	}
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

#pragma mark - Actions

- (IBAction)startNav:(id)sender
{
	[self performSegueWithIdentifier:@"ShowNavResult" sender:sender];
}

- (IBAction)swapPOIs:(id)sender
{
	// Swap the source and destination
	GGPOI *temp = self.sourcePOI;
	self.sourcePOI = self.destinationPOI;
	self.destinationPOI = temp;
	[self updateNavCells];
}

#pragma mark - Segue

- (NSArray *)navResultForCurrentConfig
{
	NSArray *result = nil;
	// Do not call calculator if is on the same edge
	if ([self.sourcePOI.edge.eId isEqualToNumber:self.destinationPOI.edge.eId]) {
		// The destination is right accross the hall way
		// TODO: represent this on the map
		NSLog(@"Navigation over same edge");
	}
	// If on the same floor
	else if ([self.sourcePOI.floorPlan.fId 
			  isEqualToNumber:self.destinationPOI.floorPlan.fId]) {
		CNPathCalculator *calculator = [[CNSameFloorPathCalculator alloc] 
										initFromPOI:self.sourcePOI 
										toPOI:self.destinationPOI];
		result = [calculator executeCalculation];
	}
	// If in the same building
	else if ([self.sourcePOI.floorPlan.building.name 
			  isEqualToString:self.destinationPOI.floorPlan.building.name]) {
		NSLog(@"Navigation between different floor");
		CNPathCalculator *calculator = [[CNSameBuildingPathCalculator alloc] 
										initFromPOI:self.sourcePOI 
										toPOI:self.destinationPOI];
		result = [calculator executeCalculation];
	}
	// If is between building
	else {
		// Not implemented yet
		NSLog(@"Navigation between different building");
	}
	return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowNavResult"]) {
		// Calculate the navigation result
		NSArray *result = [self navResultForCurrentConfig];
		
		CNNavResultViewController *vc = segue.destinationViewController;
		vc.pathNodes = result;
	}
}
@end
