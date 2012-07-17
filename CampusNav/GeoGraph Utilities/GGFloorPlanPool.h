//
//  GGFloorPlanPool.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGSystem.h"

@class CLLocation;
@class GGPOIPool;

@interface GGFloorPlanPool : NSObject

@property (nonatomic, strong, readonly) NSArray *floorPlans;

+ (GGFloorPlanPool *)floorPlanPoolOfBuilding:(NSString *)building;
+ (GGFloorPlanPool *)floorPlanPoolAtLocation:(CLLocation *)location;

@end
