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
@synthesize floorPlanView = _floorPlanView;
@synthesize floorPlanScrollView = _floorPlanScrollView;
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
	
	// Set title and adjust the views
	self.title = [NSString stringWithFormat:@"%@ %@", 
				  self.poi.floorPlan.building.abbreviation, self.poi.roomNum];
	self.floorPlanScrollView.layer.cornerRadius = 10;
	
	// Load floor plan image
	NSString *imageFilename = [NSString stringWithFormat:@"%@_%02dFLR", 
							   self.poi.floorPlan.building.abbreviation, 
							   self.poi.floorPlan.floor];
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
	self.floorPlanView.image = image;
	[self.floorPlanView sizeToFit];
	self.floorPlanScrollView.contentSize = image.size;
	
	// Center the current POI on the image
	CGFloat	width = self.floorPlanScrollView.bounds.size.width;
	CGFloat height = self.floorPlanScrollView.bounds.size.height;
	CGFloat x = self.poi.coordinate.x - width / 2;
	CGFloat y = self.poi.coordinate.y - height / 2;
	[self.floorPlanScrollView scrollRectToVisible:CGRectMake(x, y, width, height) animated:YES];
	
	[CNUICustomize customizeViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Check whether is a fav on everytime appears
	[self updateFavStatus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateFavStatus
{
	// Looking for this POI in favorites
	self.userPOI = [[CNUserProfile sharedUserProfile] userPOIbyId:self.poi.pId];
	
	// If is in fav
	if (self.userPOI != nil) {
		self.favToggleCell.textLabel.text = @"Remove from Favorites";
		
		self.favNameCell.detailTextLabel.text = self.userPOI.displayName;
		self.favNameCell.hidden = NO;
	}
	// If is not
	else {
		self.favToggleCell.textLabel.text = @"Add to Favorites";
		self.favNameCell.hidden = YES;
	}
}

#pragma mark - Actions

- (void)toggleFav:(UITableViewCell *)sender
{
	BOOL result = NO;
	// If is in favorites, remove it
	if (self.userPOI != nil) {
		result = [[CNUserProfile sharedUserProfile] removeUserPOI:self.userPOI];
	}
	// Otherwize, add it
	else {
		NSString *displayName = [NSString stringWithFormat:@"%@ %@", self.poi.floorPlan.building.abbreviation, self.poi.roomNum];
		result = [[CNUserProfile sharedUserProfile] 
				  addPOI:self.poi.pId withDisplayName:displayName];
	}
	
	// If successfully changed, update the view
	if (result) {
		[self updateFavStatus];
	}
}

- (void)setAsSource:(UITableViewCell *)sender
{
	// Post a notification
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:kCNNavConfigNotification 
	 object:self 
	 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			   kCNNavConfigTypeSource, kCNNavConfigNotificationType, 
			   self.poi, kCNNavConfigNotificationData, nil]];
	// Pop the current navigation stack to the previous one
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)setAsDestination:(UITableViewCell *)sender
{
	// Post a notification
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:kCNNavConfigNotification 
	 object:self 
	 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			   kCNNavConfigTypeDestination, kCNNavConfigNotificationType, 
			   self.poi, kCNNavConfigNotificationData, nil]];
	// Pop the current navigation stack to root
	[self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)promptFavNameChange
{
	// Pop an alert view for changing the fav name
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Favourite Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert textFieldAtIndex:0].text = self.userPOI.displayName;
	
	[alert show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	// If user clicked save
    if (buttonIndex == 1) {
		// Save it to user profile
		BOOL result = [[CNUserProfile sharedUserProfile] 
					   changeUserPOI:self.userPOI 
					   withDisplayName:[alertView textFieldAtIndex:0].text];
		// If successfully changed, update the view
		if (result) {
			[self updateFavStatus];
		}
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	// Invoke cooresponding methods upon selection
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
