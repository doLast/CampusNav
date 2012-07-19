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

@property (nonatomic, strong) NSArray *pois;
@property (nonatomic, retain) CNUserProfile *userProfile;

@end

@implementation CNUserPOIViewController

#pragma mark - Getter & Setter
@synthesize pois = _pois;
@synthesize userProfile = _userProfile;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.userProfile = [CNUserProfile sharedUserProfile];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.pois = [CNUserPOIViewController poisFromUserPOIs:self.userProfile.userPOIs];
	NSLog(@"#Favs %d", [self.pois count]);
	[self.tableView reloadData];
}

+ (NSArray *)poisFromUserPOIs:(NSArray *)userPOIs
{
	NSMutableArray *pois = [NSMutableArray arrayWithCapacity:[userPOIs count]];
	for (UserPOI *userPOI in userPOIs) {
		GGPOI *poi = [GGPOI poiWithPId:userPOI.pId];
		[pois addObject:poi];
	}
	return pois;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
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
