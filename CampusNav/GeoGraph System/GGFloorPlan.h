//
//  GGFloorPlan.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGBuilding;

@interface GGFloorPlan : NSObject

@property (nonatomic, strong, readonly) NSNumber *fId;
@property (nonatomic, readonly) GGBuilding *building;
@property (nonatomic, readonly) NSInteger floor;
@property (nonatomic, strong, readonly) NSString *description;

+ (GGFloorPlan *)floorPlanWithFid:(NSNumber *)fId 
					   inBuilding:(NSNumber *)bId 
						  onFloor:(NSInteger)floor
				  withDescription:(NSString *)description;

@end
