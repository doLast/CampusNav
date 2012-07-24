//
//  GGGraph.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPoint.h"

@class GGPOI;

@interface GGGraph : NSObject

@property (nonatomic, strong, readonly) NSDictionary *pointToEdges;

+ (GGGraph *)graphWithPointToEdges:(NSDictionary *)pointToEdges;
+ (GGGraph *)graphWithGraphs:(NSArray *)graphs;

+ (NSInteger)weightBetweenCoordinate:(GGCoordinate)a andCoordinate:(GGCoordinate)b;

- (BOOL)insertPOI:(GGPOI *)poi;

@end
