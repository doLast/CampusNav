//
//  GGSystem+GGInternalSystem.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem.h"

@class GGBuilding;
@class GGFloorPlan;
@class GGElement;
@class GGPOI;
@class GGEdge;

@interface GGSystem (GGInternalSystem)

// These methods can only be called within GeoGraph System
// Not part of public interface
- (GGBuilding *)getBuilding:(NSNumber *)bId;
- (GGFloorPlan *)getFloorPlan:(NSNumber *)fId;
- (GGEdge *)getEdge:(NSNumber *)eId;
- (GGPoint *)getPoint:(NSNumber *)pId;
- (GGElement *)getElement:(NSNumber *)pId;
- (GGPOI *)getPOI:(NSNumber *)pId;

@end
