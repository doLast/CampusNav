//
//  GGFloorPlan.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGFloorPlan : NSObject

@property (nonatomic, strong, readonly) NSNumber *fId;
@property (nonatomic, strong, readonly) NSString *building;
@property (nonatomic, readonly) NSInteger floor;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSString *abbreviation;

+ (GGFloorPlan *)floorPlanWithFid:(NSNumber *)fId 
					   inBuilding:(NSString *)building 
						  onFloor:(NSInteger)floor
					   atLocation:(CLLocation *)location 
				 withAbbreviation:(NSString *)abbreviation;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
