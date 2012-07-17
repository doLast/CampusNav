//
//  GGPoint.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	double x;
	double y;
} GGCoordinate;

@interface GGPoint : NSObject

@property (nonatomic, assign, readonly) NSInteger pId;
@property (nonatomic, assign, readonly) GGCoordinate coordinate;

@end
