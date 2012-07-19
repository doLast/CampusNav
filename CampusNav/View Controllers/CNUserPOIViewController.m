//
//  CNUserPOIViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNUserPOIViewController.h"
#import "GGSystem.h"
#import "CNUserProfile.h"

@interface CNUserPOIViewController ()

@property (nonatomic, strong, readonly) NSArray *pois;
@property (nonatomic, weak) NSArray *userPOIs;

@end

@implementation CNUserPOIViewController

#pragma mark - Getter & Setter
@synthesize pois = _pois;
@synthesize userPOIs = _userPOIs;

- (NSArray *)pois
{
	// If user POI didn't change, return the last one
	if (self.userPOIs == [CNUserProfile sharedUserProfile].userPOIs) {
		return _pois;
	}
	
	// Otherwise, reconstruct the pois
	self.userPOIs = [CNUserProfile sharedUserProfile].userPOIs;
	NSMutableArray *pois = [NSMutableArray arrayWithCapacity:[self.userPOIs count]];
	for (UserPOI *userPOI in self.userPOIs) {
		GGPOI *poi = [GGPOI poiWithPId:userPOI.pId];
		[pois addObject:poi];
	}
	
	// Set it and return
	_pois = pois;
	return _pois;
}


#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
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
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}   
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

@end
