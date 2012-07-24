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
@property (nonatomic, strong) NSNumber *bId;
@property (nonatomic) NSInteger floor;
@property (nonatomic, strong) NSString *description;

@end

@implementation GGFloorPlan

#pragma mark - Getter & Setter
@synthesize fId = _fId;
@synthesize bId = _bId;
@synthesize floor = _floor;
@synthesize description = _description;

- (GGBuilding *)building
{
	return [[GGSystem sharedGeoGraphSystem] getBuilding:self.bId];
}

#pragma mark - Convenicent Constructor
+ (GGFloorPlan *)floorPlanWithFid:(NSNumber *)fId 
					   inBuilding:(NSNumber *)bId 
						  onFloor:(NSInteger)floor 
				  withDescription:(NSString *)description
{
	GGFloorPlan *floorPlan = [[GGFloorPlan alloc] init];
	floorPlan.fId = fId;
	floorPlan.bId = bId;
	floorPlan.floor = floor;
	floorPlan.description = description;
	return floorPlan;
}


@end
