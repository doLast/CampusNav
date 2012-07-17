//
//  GGSystem+GGInternalSystem.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem+GGInternalSystem.h"
//#import "FMDatabase.h"
//#import "FMResultSet.h"
#import "GGFloorPlan.h"
#import "GGPoint.h"
#import "GGElement.h"
#import "GGPOI.h"
#import "GGEdge.h"
#import "GGGraph.h"


// Private declarations
@interface GGSystem ()
//@property (nonatomic, strong, readonly) FMDatabase *dataSource;
@property (nonatomic, strong, readonly) NSDictionary *floorPlanCache;
@property (nonatomic, strong, readonly) NSDictionary *pointCache;
@property (nonatomic, strong, readonly) NSDictionary *edgeCache;

@end

@implementation GGSystem (GGInternalSystem)

- (GGFloorPlan *)getFloorPlan:(NSNumber *)fId
{
	return [self.floorPlanCache objectForKey:fId];
}

- (GGEdge *)getEdge:(NSNumber *)eId
{
	return [self.edgeCache objectForKey:eId];
}

- (GGPoint *)getPoint:(NSNumber *)pId
{
	return [self.pointCache objectForKey:pId];
}

- (GGElement *)getElement:(NSNumber *)pId
{
	GGElement *point = [self.pointCache objectForKey:pId];
	if ([point isKindOfClass:[GGElement class]]) {
		return point;
	}
	return nil;
}

- (GGPOI *)getPOI:(NSNumber *)pId
{
	GGPOI *point = [self.pointCache objectForKey:pId];
	if ([point isKindOfClass:[GGPOI class]]) {
		return point;
	}
	return nil;
}

@end
