//
//  CNGeoGraphSelectionViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNGeoGraphSelectionViewController.h"
#import "CNCategoryTableViewController.h"

#import "CNAppDelegate.h"
#import "GGBuildingPool.h"
#import "GGFloorPlanPool.h"
#import "GGPOIPool.h"

NSString * const kCNNewPOIPoolNotification = @"CNNewPOIPoolNotification";
NSString * const kCNNewPOIPoolNotificationTitle = @"CNNewPOIPoolNotificationTitle";
NSString * const kCNNewPOIPoolNotificationData = @"CNNewPOIPoolNotificationData";

enum FloorPlanPickerViewComponents {
	kFloorPlanPickerViewBuilding = 0,
	kFloorPlanPickerViewFloor
};

@interface CNGeoGraphSelectionViewController ()
@property (nonatomic, strong) GGBuildingPool *buildingPool;
@property (nonatomic, strong) GGFloorPlanPool *floorPlanPool;
@property (nonatomic) NSInteger selectedBuilding;
@property (nonatomic) NSInteger selectedFloorPlan;
@property (nonatomic, weak, readonly) CLLocationManager *locationManager;

@property (nonatomic, strong) IBOutlet UIActionSheet *pickerActionSheet;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@end

@implementation CNGeoGraphSelectionViewController

#pragma mark - Getter & Setter
@synthesize buildingPool = _buildingPool;
@synthesize floorPlanPool = _floorPlanPool;
@synthesize selectedBuilding = _selectedBuilding;
@synthesize selectedFloorPlan = _selectedFloorPlan;

@synthesize locateButton = _locateButton;
@synthesize pickerActionSheet = _pickerActionSheet;
@synthesize pickerView = _pickerView;


- (CLLocationManager *)locationManager
{
	CNAppDelegate *appDalegate = (CNAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDalegate.locationManager;
}

#pragma mark - Initialization
- (CNGeoGraphSelectionViewController *)init
{
	self = [super init];
	if (self != nil) {
		[self initializeDataAndViews];
	}
	return self;
}

- (void)initializeDataAndViews
{	
	// Initialize data pool
	self.buildingPool = [GGBuildingPool buildingPoolOfCampus:@"University of Waterloo"];
	assert([self.buildingPool.items count] > 0);	
	self.floorPlanPool = [GGFloorPlanPool floorPlanPoolOfBuilding:[self.buildingPool.items objectAtIndex:0]];
	
	// Initialize the selected item indicators
	self.selectedBuilding = 0;
	self.selectedFloorPlan = -1;
	
	// Initialize the picker & action sheet
	// Picker view
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerView.showsSelectionIndicator = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	
	// Close button
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor colorWithRed:46.0/255 green:119.0/255 blue:173.0/255 alpha:0.0];
	[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
	
	// Action sheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose building and floor" 
															 delegate:nil
                                                    cancelButtonTitle:nil
											   destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	[actionSheet addSubview:pickerView];
	[actionSheet addSubview:closeButton];
	
	self.pickerActionSheet = actionSheet;
	self.pickerView = pickerView;
	
	// Response to location manager
	self.locationManager.delegate = self;
}

#pragma mark - Actions

- (IBAction)updateSelection:(id)sender
{	
	// Prepare the notification data
	GGPOIPool *poiPool;
	NSString *floor;
	if (self.selectedFloorPlan == -1) {
		poiPool = [GGPOIPool poiPoolOfBuilding:[self.buildingPool.items objectAtIndex:self.selectedBuilding]];
		floor = @"All";
	}
	else {
		poiPool = [GGPOIPool poiPoolOfFloorPlan:[self.floorPlanPool.items objectAtIndex:self.selectedFloorPlan]];
		floor = ((GGFloorPlan *)[self.floorPlanPool.items objectAtIndex:self.selectedFloorPlan]).description;
	}
	NSString *title = [NSString stringWithFormat:@"%@ %@", 
					   ((GGBuilding *)[self.buildingPool.items objectAtIndex:self.selectedBuilding]).abbreviation, floor];
	
	// Boradcase the update
	[[NSNotificationCenter defaultCenter] postNotificationName:kCNNewPOIPoolNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:title, kCNNewPOIPoolNotificationTitle, poiPool, kCNNewPOIPoolNotificationData, nil]];
}

- (IBAction)startLocating:(id)sender
{
	// Setup the activity indicator
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	
	self.locateButton.customView = activityIndicatorView;
	self.locateButton.customView.frame = CGRectMake(10, 0, 25, 25);
	self.locateButton.customView.hidden = NO;
	
	// Start locating, may prompt the user for previlege if is the first time
	[self.locationManager startUpdatingLocation];
	
	// If denied
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		[self stopLocating:self];
		
		// TODO: prompt the user to turn on location service
	}
	else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
		[self stopLocating:self];
		self.locateButton.enabled = NO;
	}
	
}

- (IBAction)stopLocating:(id)sender
{
	self.locateButton.customView = nil;
	
	[self.locationManager stopUpdatingLocation];
}

- (IBAction)chooseFloorPlan:(id)sender
{
	[self.pickerView selectRow:self.selectedBuilding inComponent:kFloorPlanPickerViewBuilding animated:NO];
	[self.pickerView selectRow:self.selectedFloorPlan + 1 inComponent:kFloorPlanPickerViewFloor animated:NO];
	[self.pickerActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[self.pickerActionSheet setBounds:CGRectMake(0, 0, 320, 470)];
}

- (IBAction)dismissActionSheet:(id)sender
{
	[self.pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"User Location Update to %@", newLocation);
	if (newLocation.horizontalAccuracy < 100) {
		[self stopLocating:manager];
	}
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == kFloorPlanPickerViewBuilding) {
		return [self.buildingPool.items count];
	}
	else if (component == kFloorPlanPickerViewFloor) {
		return [self.floorPlanPool.items count] + 1;
	}
	return 0;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == kFloorPlanPickerViewBuilding) {
		self.selectedBuilding = row;
	}
	else if (component == kFloorPlanPickerViewFloor) {
		self.selectedFloorPlan = row - 1;
	}
	[self updateSelection:pickerView];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == kFloorPlanPickerViewBuilding) {
		GGBuilding *building = [self.buildingPool.items objectAtIndex:row];
		return [NSString stringWithFormat:@"%@ - %@", building.abbreviation, building.name];
	}
	else if (component == kFloorPlanPickerViewFloor) {
		if (row == 0) {
			return [NSString stringWithFormat:@"All"];
		}
		GGFloorPlan *floorPlan = [self.floorPlanPool.items objectAtIndex:row - 1];
		return [NSString stringWithFormat:@"%@", floorPlan.description];
	}
	return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == kFloorPlanPickerViewBuilding) {
		return 220.0;
	}
	else if (component == kFloorPlanPickerViewFloor) {
		return 60.0;
	}
	return 0;
}

@end
