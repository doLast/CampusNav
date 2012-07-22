//
//  CNCategoryTableViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNCategoryTableViewController.h"
#import "CNGeoGraphSelectionViewController.h"
#import "CNPOITableViewController.h"
#import "CNPOIDetailViewController.h"
#import "CNUICustomize.h"

#import "GGFloorPlanPool.h"
#import "GGPOIPool.h"

@interface CNCategoryTableViewController ()
// private attributes
@property (nonatomic, strong) GGPOIPool *poiPool;
@property (nonatomic, strong) CNGeoGraphSelectionViewController *selectionViewController;

@end

@implementation CNCategoryTableViewController

#pragma mark - Getter & Setter
@synthesize poiPool = _poiPool;
@synthesize selectionViewController = _selectionViewController;

@synthesize locateButton = _locateButton;
@synthesize searchResultTableDelegate = _searchResultTableDelegate;

- (void)setPoiPool:(GGPOIPool *)poiPool
{
	_poiPool = poiPool;
	if ([self isViewLoaded]) {
		[self.tableView reloadData];
	}
}

#pragma makr - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
		
	self.selectionViewController = [[CNGeoGraphSelectionViewController alloc] init];
	self.selectionViewController.locateButton = self.locateButton;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewPOIPoolNotification:) name:kCNNewPOIPoolNotification object:self.selectionViewController];
	
	[CNUICustomize customizeViewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.selectionViewController updateSelection:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleNewPOIPoolNotification:(NSNotification *)notification
{
	NSString *title = [notification.userInfo objectForKey:kCNNewPOIPoolNotificationTitle];
	self.title = title;
	
	GGPOIPool *pool = [notification.userInfo objectForKey:kCNNewPOIPoolNotificationData];
	self.poiPool = pool;
	[self.tableView reloadData];
}

#pragma mark - Actions
- (IBAction)startLocating:(id)sender
{
	[self.selectionViewController startLocating:sender];
}

- (IBAction)chooseFloorPlan:(id)sender
{
	[self.selectionViewController chooseFloorPlan:sender];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return kGGPOICategoryEnd;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	cell.textLabel.text = GGPOICategoryNames[indexPath.row];
	if (self.poiPool == nil) {
		cell.detailTextLabel.text = @"0";								
	}
	else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", 
									 [[self.poiPool poisWithinCategory:indexPath.row] count]];
	}
    
    return cell;
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

#pragma mark - Search Display Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	if ([searchString length] > 0) {
		NSArray *pois = [self.poiPool poisLikeKeyword:searchString];
		self.searchResultTableDelegate.poiPool = [GGPOIPool poiPoolWithPOIs:pois];
		return YES;
	}
	return NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[UITableViewCell class]]) {
		UITableViewCell *cell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		CNPOITableViewController *vc = segue.destinationViewController;
		
		vc.poiPool = [GGPOIPool poiPoolWithPOIs:[self.poiPool poisWithinCategory:indexPath.row]];
		vc.title = cell.textLabel.text;
	}
	else if ([sender isKindOfClass:[GGPOI class]]) {
		CNPOIDetailViewController *vc = segue.destinationViewController;
		
		vc.poi = sender;
	}
}

@end
