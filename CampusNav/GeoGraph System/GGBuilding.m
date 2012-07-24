//
//  GGBuilding.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGBuilding.h"

@interface GGBuilding ()

@property (nonatomic, strong) NSNumber *bId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *abbreviation;
@property (nonatomic, strong) CLLocation *location;

@end

@implementation GGBuilding

#pragma mark - Getter & Setter
@synthesize bId = _bId;
@synthesize name = _name;
@synthesize abbreviation = _abbreviation;
@synthesize location = _location;

#pragma mark - Convenicent Constructor
+ (GGBuilding *)buildingWithBId:(NSNumber *)bId 
					   withName:(NSString *)name 
			   withAbbreviation:(NSString *)abbreviation 
					 atLocation:(CLLocation *)location
{
	GGBuilding *building = [[GGBuilding alloc] init];
	building.bId = bId;
	building.name = name;
	building.abbreviation = abbreviation;
	building.location = location;
	return building;
}


#pragma mark - methods
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
	return [self.location distanceFromLocation:location];
}

@end
