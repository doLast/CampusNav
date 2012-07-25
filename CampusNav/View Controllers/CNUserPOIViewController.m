//
//  CNUserPOIViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNUserPOIViewController.h"
#import "CNPOIDetailViewController.h"
#import "CNUICustomize.h"

#import "GGSystem.h"
#import "CNUserProfile.h"

@interface CNUserPOIViewController ()
@property (nonatomic, weak, readonly) NSArray *userPOIs;

@end

@implementation CNUserPOIViewController

#pragma mark - Getter & Setter
- (NSArray *)userPOIs
{
	return [CNUserProfile sharedUserProfile].userPOIs;
}

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[CNUICustomize customizeViewController:self];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[[CNUserProfile sharedUserProfile] removeUserPOI:[self.userPOIs objectAtIndex:indexPath.row]];
		// Delete the row from table
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} 
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.userPOIs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue a cell
    static NSString *CellIdentifier = @"POICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	// Customize it with data
	UserPOI *userPOI = [self.userPOIs objectAtIndex:indexPath.row];
	GGPOI *poi = userPOI.poi;
	
	cell.textLabel.text = [userPOI.displayName copy];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", poi.description];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[UITableViewCell class]]) {
		UITableViewCell *cell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		CNPOIDetailViewController *vc = segue.destinationViewController;
		
		vc.poi = ((UserPOI *)[self.userPOIs objectAtIndex:indexPath.row]).poi;
	}
}

@end
