//
//  GGFloorPlanPool.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGFloorPlanPool.h"
#import "GGSystem.h"

@interface GGFloorPlanPool ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation GGFloorPlanPool

#pragma mark - Getter & Setter
@synthesize items = _items;

#pragma mark - Convenient constructors
+ (GGFloorPlanPool *)floorPlanPoolOfCampus:(NSString *)campus
{
	GGFloorPlanPool *pool = [[GGFloorPlanPool alloc] init];
	pool.items = [[GGSystem sharedGeoGraphSystem] floorPlansOfCampus:campus];
	return pool;
}

+ (GGFloorPlanPool *)floorPlanPoolOfBuilding:(GGBuilding *)building
{
	GGFloorPlanPool *pool = [[GGFloorPlanPool alloc] init];
	pool.items = [[GGSystem sharedGeoGraphSystem] floorPlansOfBuilding:building];
	return pool;
}

+ (GGFloorPlanPool *)floorPlanPoolAtLocation:(CLLocation *)location
{
	// TODO
	return nil;
}

@end
