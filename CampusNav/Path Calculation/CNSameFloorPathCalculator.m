//
//  CNSameFloorPathCalculator.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNSameFloorPathCalculator.h"
#import "GGSystem.h"

@interface CNSameFloorPathCalculator ()

@property (nonatomic, strong) GGGraph *floorGraph;

@end

@implementation CNSameFloorPathCalculator

@synthesize floorGraph = _floorGraph;

- (void)getData
{
	self.floorGraph = [[GGSystem sharedGeoGraphSystem] graphOfFloorPlan:self.source.floorPlan];
}

- (void)insertSource:(GGPOI *)source andDestination:(GGPOI *)destination
{
	BOOL result;
	result = [self.floorGraph insertPOI:source];
	assert(result == YES);
	result = [self.floorGraph insertPOI:destination];
	assert(result == YES);
}

- (NSDictionary *)calculatePath
{
	NSDictionary *previous = [CNPathCalculator dijkstraWithGraph:self.floorGraph fromSource:self.source toDestination:self.destination];
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
