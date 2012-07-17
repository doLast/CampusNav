//
//  GGEdge.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGEdge.h"

@interface GGEdge ()

@property (nonatomic, assign) NSInteger eId;
@property (nonatomic, retain) GGPoint *vertexA;
@property (nonatomic, retain) GGPoint *vertexB;
@property (nonatomic, assign) NSInteger weight;

@end

@implementation GGEdge

@synthesize eId = _eId;
@synthesize vertexA = _vertexA;
@synthesize vertexB = _vertexB;
@synthesize weight = _weight;

@end
