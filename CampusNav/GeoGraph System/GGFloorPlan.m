//
//  GGFloorPlan.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGFloorPlan.h"
#import <CoreLocation/CoreLocation.h>

@interface GGFloorPlan ()

@property (nonatomic, assign) NSInteger fId;
@property (nonatomic, retain) NSString *building;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *abbreviation;

@end

@implementation GGFloorPlan

#pragma mark - Getter & Setter
@synthesize fId = _fId;
@synthesize building = _building;
@synthesize floor = _floor;
@synthesize location = _location;
@synthesize abbreviation = _abbreviation;

#pragma mark - Convenicent Constructor
+ (GGFloorPlan *)floorPlanWithFid:(NSInteger)fId 
					   inBuilding:(NSString *)building 
						  onFloor:(NSInteger)floor 
					   atLocation:(CLLocation *)location 
				 withAbbreviation:(NSString *)abbreviation
{
	GGFloorPlan *floorPlan = [[GGFloorPlan alloc] init];
	floorPlan.fId = fId;
	floorPlan.building = building;
	floorPlan.floor = floor;
	floorPlan.location = location;
	floorPlan.abbreviation = abbreviation;
	return floorPlan;
}

#pragma mark - methods
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
	return [self.location distanceFromLocation:location];
}

@end
