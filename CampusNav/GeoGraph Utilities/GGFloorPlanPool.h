//
//  GGFloorPlanPool.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPool.h"
#import "GGSystem.h"

@class GGBuilding;

@interface GGFloorPlanPool : GGPool

+ (GGFloorPlanPool *)floorPlanPoolOfBuilding:(GGBuilding *)building;

@end
