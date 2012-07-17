//
//  CNPOIPool.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGSystem.h"

@interface GGPOIPool : NSObject

@property (nonatomic, strong, readonly) NSArray *pois;

//+ (GGPOIPool *)poiPoolWithBuilding:(NSString *)building andFloor:(NSInteger)floor;
+ (GGPOIPool *)poiPoolOfFloorPlan:(GGFloorPlan *)floorPlan;
- (NSArray *)poisWithinCategory:(GGPOICategory)category;

@end
