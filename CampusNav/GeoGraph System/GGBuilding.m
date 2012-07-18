//
//  GGBuilding.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGBuilding.h"

@interface GGBuilding ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *abbreviation;

@end

@implementation GGBuilding

@synthesize name = _name;
@synthesize location = _location;
@synthesize abbreviation = _abbreviation;

+ (GGBuilding *)buildingWithName:(NSString *)name withAbbreviation:(NSString *)abbreviation atLocation:(CLLocation *)location
{
	GGBuilding *building = [[GGBuilding alloc] init];
	building.name = name;
	building.location = location;
	building.abbreviation = abbreviation;
	return building;
}


#pragma mark - methods
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
	return [self.location distanceFromLocation:location];
}

@end
