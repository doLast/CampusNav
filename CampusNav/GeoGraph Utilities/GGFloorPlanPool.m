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

@property (nonatomic, strong) NSArray *floorPlans;

@end

@implementation GGFloorPlanPool

@synthesize floorPlans;

+ (GGFloorPlanPool *)floorPlanPoolOfBuilding:(NSString *)building
{
	GGFloorPlanPool *pool = [[GGFloorPlanPool alloc] init];
	pool.floorPlans = [[GGSystem sharedGeoGraphSystem] floorPlansOfBuilding:building];
	return pool;
}

+ (GGFloorPlanPool *)floorPlanPoolAtLocation:(CLLocation *)location
{
	// TODO
	return nil;
}

@end
