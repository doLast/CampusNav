//
//  GGBuildingPool.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGBuildingPool.h"
#import "GGSystem.h"

@interface GGBuildingPool ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation GGBuildingPool

@synthesize items = _items;

+ (GGBuildingPool *)buildingPoolOfCampus:(NSString *)campus
{
	GGBuildingPool *pool = [[GGBuildingPool alloc] init];
	pool.items = [[GGSystem sharedGeoGraphSystem] buildingInCampus:campus];
	return pool;
}

@end
