//
//  GGPOIPool.m
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

#pragma mark - Getter & Setter
@synthesize items = _items;

#pragma mark - Convenient constructors
+ (GGPOIPool *)poiPoolWithPOIs:(NSArray *)pois
{
	GGPOIPool *pool = [[GGPOIPool alloc] init];
	pool.items = pois;
	return pool;
}

+ (GGPOIPool *)poiPoolOfBuilding:(GGBuilding *)building
{
	return [GGPOIPool poiPoolWithPOIs:[[GGSystem sharedGeoGraphSystem] poisInBuilding:building]];
}

+ (GGPOIPool *)poiPoolOfFloorPlan:(GGFloorPlan *)floorPlan
{
	return [GGPOIPool poiPoolWithPOIs:[[GGSystem sharedGeoGraphSystem] poisOnFloorPlan:floorPlan]];
}

#pragma mark - Utility methods
- (NSArray *)poisWithinCategory:(GGPOICategory)category
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category=%d", category];
	NSArray *result = [self.items filteredArrayUsingPredicate:predicate];
	return result;
}

- (NSArray *)poisLikeKeyword:(NSString *)keyword
{
	NSArray *components = [keyword componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSMutableArray *subpredicates = [NSMutableArray array];
	
	for (NSString *component in components) {
		if([component length] == 0) { continue; }
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomNum contains[cd] %@ || description contains[cd] %@", component, component];
		[subpredicates addObject:predicate];
	}
	
	return [self.items filteredArrayUsingPredicate:
			[NSCompoundPredicate andPredicateWithSubpredicates:subpredicates]];
}

@end
