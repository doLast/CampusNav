//
//  GGPoint.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPoint.h"
#import "GGSystem+GGInternalSystem.h"

@interface GGPoint ()
@property (nonatomic, strong) NSNumber *fId;

@end

@implementation GGPoint

@synthesize pId = _pId;
@synthesize fId = _fId;
@synthesize coordinate = _coordinate;

- (GGFloorPlan *)floorPlan
{
	return [[GGSystem sharedGeoGraphSystem] getFloorPlan:self.fId];
}

+ (GGCoordinate)coordinateAtX:(NSInteger)x andY:(NSInteger)y
{
	GGCoordinate coordinate;
	coordinate.x = x;
	coordinate.y = y;
	return coordinate;
}

@end
