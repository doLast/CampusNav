//
//  CNNavResultViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavResultViewController.h"
#import "GGSystem.h"

@interface CNNavResultViewController ()

@end

@implementation CNNavResultViewController

#pragma mark - Getter & Setter
@synthesize resultPoints = _resultPoints;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NavResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	GGPoint *point = [self.resultPoints objectAtIndex:indexPath.row];
	
	if ([point isKindOfClass:[GGPOI class]]) {
		GGPOI *poi = (GGPOI *)point;
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", poi.floorPlan.building.abbreviation, poi.roomNum];
	}
	else if ([point isKindOfClass:[GGElement class]]) {
		GGElement *element = (GGElement *)point;
		cell.textLabel.text = [NSString stringWithFormat:@"%@ #%@", GGElementTypeText[element.elementType], element.pId];
	}
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %d floor", point.floorPlan.building.abbreviation, point.floorPlan.floor];
	
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

@end
