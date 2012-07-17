//
//  GGGraph.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPOI;
@class GGEdge;

@interface GGGraph : NSObject

@property (nonatomic, copy) GGPOI *source;
@property (nonatomic, copy) GGPOI *destination;
@property (nonatomic, strong, readonly) NSArray *edges;
@property (nonatomic, strong, readonly) NSArray *elements;

- (BOOL)addEdge:(GGEdge *)edge;

@end
