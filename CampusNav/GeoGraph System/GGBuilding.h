//
//  GGBuilding.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBuilding : NSObject

@property (nonatomic, strong, readonly) NSNumber *bId;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *abbreviation;
@property (nonatomic, strong, readonly) CLLocation *location;

+ (GGBuilding *)buildingWithBId:(NSNumber *)bId 
					   withName:(NSString *)name 
			   withAbbreviation:(NSString *)abbreviation 
					 atLocation:(CLLocation *)location;

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
