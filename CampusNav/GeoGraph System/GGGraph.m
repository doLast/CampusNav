//
//  GGGraph.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGGraph.h"

@interface GGGraph ()

@property (nonatomic, retain) NSArray *edges;
@property (nonatomic, retain) NSArray *elements;

@end

@implementation GGGraph

@synthesize source = _source;
@synthesize destination = _destination;
@synthesize edges = _edges;
@synthesize elements = _elements;

- (BOOL)addEdge:(GGEdge *)edge 
{
	
	return NO;
}

@end
