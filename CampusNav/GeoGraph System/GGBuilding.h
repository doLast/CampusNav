//
//  GGBuilding.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGBuilding : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSString *abbreviation;

+ (GGBuilding *)buildingWithName:(NSString *)name withAbbreviation:(NSString *)abbreviation atLocation:(CLLocation *)location;

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
