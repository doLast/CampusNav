//
//  GGPOIPool.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPool.h"
#import "GGSystem.h"

@class GGFloorPlan;

@interface GGPOIPool : GGPool

+ (GGPOIPool *)poiPoolWithPOIs:(NSArray *)pois;
+ (GGPOIPool *)poiPoolOfBuilding:(GGBuilding *)building;
+ (GGPOIPool *)poiPoolOfFloorPlan:(GGFloorPlan *)floorPlan;

- (NSArray *)poisWithinCategory:(GGPOICategory)category;
- (NSArray *)poisLikeKeyword:(NSString *)keyword;

@end
