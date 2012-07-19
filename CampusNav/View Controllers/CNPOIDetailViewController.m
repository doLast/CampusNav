//
//  CNPOIDetailViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPOIDetailViewController.h"
#import "GGSystem.h"
#import "CNUserProfile.h"

@interface CNPOIDetailViewController ()

@property (nonatomic, strong) UserPOI *userPOI;

@end

@implementation CNPOIDetailViewController

#pragma mark - Getter & Setter
@synthesize poi = _poi;
@synthesize mapImageView = _mapImageView;
@synthesize favToggleCell = _favToggleCell;
@synthesize favNameCell = _favNameCell;

@synthesize userPOI = _userPOI;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if (self.poi == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	self.title = [NSString stringWithFormat:@"%@", self.poi.roomNum];
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
	
	[self updateFavStatus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateFavStatus
{
	self.userPOI = [[CNUserProfile sharedUserProfile] userPOIbyId:self.poi.pId];
	
	if (self.userPOI != nil) {
		self.favToggleCell.textLabel.text = @"REMOVE_POI_FROM_FAV";
		
		self.favNameCell.textLabel.text = self.userPOI.displayName;
		self.favNameCell.hidden = NO;
	}
	else {
		self.favToggleCell.textLabel.text = @"ADD_POI_TO_FAV";
		self.favNameCell.hidden = YES;
	}
}

#pragma mark - Actions

- (void)toggleFav:(UITableViewCell *)sender
{
	BOOL result = NO;
	if (self.userPOI != nil) {
		result = [[CNUserProfile sharedUserProfile] removeUserPOI:self.userPOI];
	}
	else {
		NSString *displayName = [NSString stringWithFormat:@"%@ %@", self.poi.floorPlan.building.abbreviation, self.poi.roomNum];
		result = [[CNUserProfile sharedUserProfile] 
				  addPOI:self.poi.pId withDisplayName:displayName];
	}
	if (result) {
		[self updateFavStatus];
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1 && indexPath.row == 1) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[self toggleFav:cell];
		cell.selected = NO;
	}
}

@end
