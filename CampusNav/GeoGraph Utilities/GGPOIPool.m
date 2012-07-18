//
//  GGFloorPlan.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPOIPool.h"
#import "GGSystem.h"

@interface GGPOIPool ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation GGPOIPool

@synthesize items = _items;

+ (GGPOIPool *)poiPoolOfBuilding:(GGBuilding *)building
{
	GGPOIPool *pool = [[GGPOIPool alloc] init];
	pool.items = [[GGSystem sharedGeoGraphSystem] poisInBuilding:building];
	return pool;
}

+ (GGPOIPool *)poiPoolOfFloorPlan:(GGFloorPlan *)floorPlan
{
	GGPOIPool *pool = [[GGPOIPool alloc] init];
	NSLog(@"Creating poi pool from floor plan %@", floorPlan.fId);
	pool.items = [[GGSystem sharedGeoGraphSystem] poisOnFloorPlan:floorPlan];
	return pool;
}

- (NSArray *)poisWithinCategory:(GGPOICategory)category
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category=%d", category];
	NSArray *result = [self.items filteredArrayUsingPredicate:predicate];
	return result;
}

@end
