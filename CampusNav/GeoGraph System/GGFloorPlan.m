//
//  GGFloorPlan.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGFloorPlan.h"
#import "GGSystem+GGInternalSystem.h"

@interface GGFloorPlan ()

@property (nonatomic, strong) NSNumber *fId;
@property (nonatomic, strong) NSString *buildingName;
@property (nonatomic) NSInteger floor;

@end

@implementation GGFloorPlan

#pragma mark - Getter & Setter
@synthesize fId = _fId;
@synthesize buildingName = _buildingName;
@synthesize floor = _floor;

- (GGBuilding *)building
{
	return [[GGSystem sharedGeoGraphSystem] getBuilding:self.buildingName];
}

#pragma mark - Convenicent Constructor
+ (GGFloorPlan *)floorPlanWithFid:(NSNumber *)fId 
					   inBuilding:(NSString *)buildingName 
						  onFloor:(NSInteger)floor 
{
	GGFloorPlan *floorPlan = [[GGFloorPlan alloc] init];
	floorPlan.fId = fId;
	floorPlan.buildingName = buildingName;
	floorPlan.floor = floor;
	return floorPlan;
}


@end
