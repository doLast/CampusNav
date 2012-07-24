//
//  CNPOIDetailViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPOIDetailViewController.h"
#import "CNNavConfigViewController.h"
#import "CNUICustomize.h"

#import "GGSystem.h"
#import "CNUserProfile.h"

#import <QuartzCore/QuartzCore.h>

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
	
	if (self.poi == nil) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	self.title = [NSString stringWithFormat:@"%@ %@", 
				  self.poi.floorPlan.building.abbreviation, self.poi.roomNum];
	self.mapImageView.layer.cornerRadius = 10;
	
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
		
		self.favNameCell.detailTextLabel.text = self.userPOI.displayName;
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

- (void)setAsSource:(UITableViewCell *)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kCNNavConfigNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kCNNavConfigTypeSource, kCNNavConfigNotificationType, self.poi, kCNNavConfigNotificationData, nil]];
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)setAsDestination:(UITableViewCell *)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kCNNavConfigNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kCNNavConfigTypeDestination, kCNNavConfigNotificationType, self.poi, kCNNavConfigNotificationData, nil]];
	[self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)promptFavNameChange
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Favourite Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert textFieldAtIndex:0].text = self.userPOI.displayName;
	
	[alert show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
		BOOL result = [[CNUserProfile sharedUserProfile] 
					   changeUserPOI:self.userPOI 
					   withDisplayName:[alertView textFieldAtIndex:0].text];
		if (result) {
			[self updateFavStatus];
		}
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (indexPath.section == 1 && indexPath.row == 0) {
		[self setAsSource:cell];
	}
	else if (indexPath.section == 1 && indexPath.row == 1) {
		[self setAsDestination:cell];
	}
	else if (indexPath.section == 1 && indexPath.row == 2) {
		[self toggleFav:cell];
	}
	else if (indexPath.section == 2 && indexPath.row == 0) {
		[self promptFavNameChange];
	}
	cell.selected = NO;
}

@end
