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

- (NSArray *)parseCalculationResult:(NSDictionary *)result
{
	NSMutableArray *path = [NSMutableArray array];
	
	// Add Destination's GGPOI to path
	NSNumber *pId = self.destination.pId;
	[path addObject:[GGPOI poiWithPId:self.destination.pId]];
	
	// Add all GGElement(s) in between to path
	for (pId = [result objectForKey:pId]; pId != nil && pId != self.source.pId; pId = [result objectForKey:pId]) {
		[path addObject:[GGElement elementWithPId:pId]];
	}
	// Add Source's GGPOI to path
	[path addObject:[GGPOI poiWithPId:self.source.pId]];
	
	// Return reversed result
	return [[path reverseObjectEnumerator] allObjects];
}

@end

