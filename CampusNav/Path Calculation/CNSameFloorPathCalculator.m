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
	NSDictionary *previous = [CNPathCalculator dijkstraWithGraph:self.floorGraph 
													  fromSource:self.source 
												   toDestination:self.destination];
	return previous;
}

@end
