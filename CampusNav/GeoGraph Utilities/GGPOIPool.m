//
//  CNPOIPool.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPOIPool.h"
#import "GGSystem.h"

@interface GGPOIPool ()

@property (nonatomic, strong) NSArray *pois;

@end

@implementation GGPOIPool

@synthesize pois = _pois;

//+ (GGPOIPool *)poiPoolWithBuilding:(NSString *)building andFloor:(NSInteger)floor
//{
//	GGPOIPool *poiPool = [[GGPOIPool alloc] init];
//	// TODO Initialize the pool
//	return poiPool;
//}

+ (GGPOIPool *)poiPoolOfFloorPlan:(GGFloorPlan *)floorPlan
{
	GGPOIPool *pool = [[GGPOIPool alloc] init];
	pool.pois = [[GGSystem sharedGeoGraphSystem] poisOnFloorPlan:floorPlan];
	return pool;
}

- (NSArray *)poisWithinCategory:(GGPOICategory)category
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category=%d", category];
	NSArray *result = [self.pois filteredArrayUsingPredicate:predicate];
	return result;
}

@end
