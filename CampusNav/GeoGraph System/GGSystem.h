//
//  GGSystem.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGFloorPlan.h"
#import "GGPoint.h"
#import "GGElement.h"
#import "GGPOI.h"
#import "GGEdge.h"
#import "GGGraph.h"

@interface GGSystem : NSObject

+ (GGSystem *)sharedGeoGraphSystem;

- (NSArray *)floorPlansOfBuilding:(NSString *)building;
- (NSArray *)poisInBuilding:(NSString *)building;
- (NSArray *)poisOnFloorPlan:(GGFloorPlan *)floorPlan;
- (GGGraph *)graphOfFloorPlan:(GGFloorPlan *)floorPlan;
- (GGGraph *)graphFrom:(GGPoint *)source to:(GGPoint *)destination;

@end
