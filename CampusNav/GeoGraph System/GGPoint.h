//
//  GGPoint.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	NSInteger x;
	NSInteger y;
} GGCoordinate;

@class GGFloorPlan;

@interface GGPoint : NSObject

@property (nonatomic, readonly) NSNumber *pId;
@property (nonatomic, weak, readonly) GGFloorPlan *floorPlan;
@property (nonatomic, readonly) GGCoordinate coordinate;

+ (GGCoordinate)coordinateAtX:(NSInteger)x andY:(NSInteger)y;

@end
