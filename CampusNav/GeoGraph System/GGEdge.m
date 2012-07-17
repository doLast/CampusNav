//
//  GGEdge.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGEdge.h"
#import "GGSystem+GGInternalSystem.h"

@interface GGEdge ()

@property (nonatomic, strong) NSNumber *eId;
@property (nonatomic, strong) NSNumber *pIdA;
@property (nonatomic, strong) NSNumber *pIdB;
@property (nonatomic) NSInteger weight;

@end

@implementation GGEdge

@synthesize eId = _eId;
@synthesize pIdA = _pIdA;
@synthesize pIdB = _pIdB;
@synthesize weight = _weight;

- (GGPoint *)vertexA
{
	return [[GGSystem sharedGeoGraphSystem] getPoint:self.pIdA];
}

- (GGPoint *)vertexB
{
	return [[GGSystem sharedGeoGraphSystem] getPoint:self.pIdB];
}

@end
