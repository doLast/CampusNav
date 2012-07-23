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

#pragma mark - Getter & Setter
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

#pragma mark - Convenicent Constructor
+ (GGEdge *)edgeWithEId:(NSNumber *)eId 
		  connectsPoint:(NSNumber *)pIdA 
			   andPoint:(NSNumber *)pIdB 
			 haveWeight:(NSInteger)weight
{
	GGEdge *edge = [[GGEdge alloc] init];
	edge.eId = eId;
	edge.pIdA = pIdA;
	edge.pIdB = pIdB;
	edge.weight = weight;
	return edge;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Edge:%@ from:%@ to:%@ weight:%d", self.eId, self.pIdA, self.pIdB, self.weight];
}

@end
