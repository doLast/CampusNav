//
//  CNPOITableViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPOITableViewController.h"
#import "CNPOIDetailViewController.h"
#import "CNUICustomize.h"

#import "GGPOIPool.h"

@interface CNPOITableViewController ()

@end

@implementation CNPOITableViewController

#pragma mark - Getter & Setter
@synthesize pois = _pois;

#pragma mark - View controller events
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[CNUICustomize customizeViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue a cell
    static NSString *CellIdentifier = @"POICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	// Customize it with data
	GGPOI *poi = [self.pois objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", poi.floorPlan.building.abbreviation, poi.roomNum];
	cell.detailTextLabel.text = poi.description;
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[UITableViewCell class]]) {
		UITableViewCell *cell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		CNPOIDetailViewController *vc = segue.destinationViewController;
		
		vc.poi = [self.pois objectAtIndex:indexPath.row];
	}
}

@end
