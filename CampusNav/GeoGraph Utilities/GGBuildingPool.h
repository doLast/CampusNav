//
//  GGBuildingPool.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPool.h"
#import "GGSystem.h"

@interface GGBuildingPool : GGPool

+ (GGBuildingPool *)buildingPoolOfCampus:(NSString *)campus;

@end
