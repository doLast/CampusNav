//
//  GGFloorPlan.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GGFloorPlan : NSObject

@property (nonatomic, assign, readonly) NSInteger fId;
@property (nonatomic, retain, readonly) NSString *building;
@property (nonatomic, assign, readonly) NSInteger floor;
@property (nonatomic, retain, readonly) CLLocation *location;
@property (nonatomic, retain, readonly) NSString *abbreviation;

+ (GGFloorPlan *)floorPlanWithFid:(NSInteger)fId 
					   inBuilding:(NSString *)building 
						  onFloor:(NSInteger)floor
					   atLocation:(CLLocation *)location 
				 withAbbreviation:(NSString *)abbreviation;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
