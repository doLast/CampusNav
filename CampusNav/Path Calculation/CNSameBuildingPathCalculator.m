//
//  CNSameBuildingPathCalculator.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNSameBuildingPathCalculator.h"
#import "GGSystem.h"

@interface CNSameBuildingPathCalculator ()

@property (nonatomic, strong) GGGraph *floorsGraph;

@end

@implementation CNSameBuildingPathCalculator

@synthesize floorsGraph = _floorsGraph;

- (void)getData
{
	GGGraph *sourceFloor = [[GGSystem sharedGeoGraphSystem] graphOfFloorPlan:self.source.floorPlan];
	GGGraph *destinationFloor = [[GGSystem sharedGeoGraphSystem] graphOfFloorPlan:self.destination.floorPlan];
	self.floorsGraph = [GGGraph graphWithGraphs:[NSArray arrayWithObjects:sourceFloor, destinationFloor, nil]];
}

- (void)insertSource:(GGPOI *)source andDestination:(GGPOI *)destination
{
	BOOL result;
	result = [self.floorsGraph insertPOI:source];
	assert(result == YES);
	result = [self.floorsGraph insertPOI:destination];
	assert(result == YES);
}

- (NSDictionary *)calculatePath
{
	NSDictionary *previous = [CNPathCalculator dijkstraWithGraph:self.floorsGraph 
													  fromSource:self.source 
												   toDestination:self.destination];
	return previous;
}

@end

