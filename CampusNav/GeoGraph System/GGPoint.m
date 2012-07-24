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

#pragma mark - Getter & Setter
@synthesize pId = _pId;
@synthesize fId = _fId;
@synthesize coordinate = _coordinate;

- (GGFloorPlan *)floorPlan
{
	return [[GGSystem sharedGeoGraphSystem] getFloorPlan:self.fId];
}

#pragma mark - Coordinate Constructor
+ (GGCoordinate)coordinateAtX:(NSInteger)x andY:(NSInteger)y
{
	GGCoordinate coordinate;
	coordinate.x = x;
	coordinate.y = y;
	return coordinate;
}

- (NSString *)description
{
	NSString *str = [NSString stringWithFormat:@"point at %d, %d", self.coordinate.x, self.coordinate.y];
	return str;
}

@end
