//
//  GGGraph.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGGraph.h"
#import "GGEdge.h"
#import "GGElement.h"
#import "GGPOI.h"

@interface GGGraph ()

@property (nonatomic, strong) NSMutableDictionary *pointToEdgesCopy;
@property (nonatomic, strong) NSMutableSet *poiIds;

@end

@implementation GGGraph

#pragma mark - Getter & Setter
@synthesize pointToEdgesCopy = _pointToEdges;
@synthesize poiIds = _poiIds;

- (NSDictionary *)pointToEdges
{
	return self.pointToEdgesCopy;
}

#pragma mark
//+ (GGGraph *)graphWithEdges:(NSSet *)edges
//{
//	GGGraph *graph = [[GGGraph alloc] init];
//	if (graph != nil) {
//		NSMutableDictionary *edgesDic = 
//		[NSMutableDictionary dictionaryWithCapacity:[edges count]];
//		NSMutableDictionary *pointsDic = [NSMutableDictionary dictionary];
//		
//		for (GGEdge *edge in edges) {
//			[edgesDic setObject:edge forKey:edge.eId];
//			[pointsDic setObject:edge.vertexA forKey:edge.vertexA.pId];
//			[pointsDic setObject:edge.vertexB forKey:edge.vertexB.pId];
//		}
//		
//		graph.edgesDic = edgesDic;
//		graph.pointsDic = pointsDic;
//		graph.pois = [NSMutableSet set];
//	}
//	return graph;
//}

+ (GGGraph *)graphWithPointToEdges:(NSDictionary *)pointToEdges
{
	GGGraph *graph = [[GGGraph alloc] init];
	if (graph != nil) {
		graph.pointToEdgesCopy = [pointToEdges mutableCopy];
		graph.poiIds = [NSMutableSet set];
	}
	return graph;
}

+ (NSInteger)weightBetweenCoordinate:(GGCoordinate)a andCoordinate:(GGCoordinate)b
{
	return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

- (BOOL)insertPOI:(GGPOI *)poi
{
	// Check whether this poi has been insert before
	if ([self.poiIds containsObject:poi.pId]) {
		// Already in 
		return NO;
	}
	
	// Construct edges
	NSInteger baseId = 0 - [self.poiIds count] - 1;
	GGEdge *splitingEdge = poi.edge;
	GGEdge *edgeA = 
	[GGEdge edgeWithEId:[NSNumber numberWithInteger:baseId * 10 + 1] 
		  connectsPoint:splitingEdge.vertexA.pId 
			   andPoint:poi.pId 
			 haveWeight:[GGGraph weightBetweenCoordinate:splitingEdge.vertexA.coordinate 
										   andCoordinate:poi.coordinate]];
	GGEdge *edgeB = 
	[GGEdge edgeWithEId:[NSNumber numberWithInteger:baseId * 10 + 1] 
		  connectsPoint:splitingEdge.vertexB.pId 
			   andPoint:poi.pId 
			 haveWeight:[GGGraph weightBetweenCoordinate:splitingEdge.vertexB.coordinate 
										   andCoordinate:poi.coordinate]];
	// Add edges to vertices
	NSMutableSet *edgesA = [self.pointToEdges objectForKey:splitingEdge.vertexA.pId];
	[edgesA addObject:edgeA];
	NSMutableSet *edgesB = [self.pointToEdges objectForKey:splitingEdge.vertexB.pId];
	[edgesB addObject:edgeB];
	
	// Insert new poiWithEdges
	NSMutableSet *edges = [NSMutableSet setWithObjects:edgeA, edgeB, nil];
	[self.pointToEdgesCopy setObject:edges forKey:poi.pId];
	
	// Insert into POI Ids
	[self.poiIds addObject:poi.pId];
	
	return YES;
}

@end
