//
//  GGEdge.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPoint;

@interface GGEdge : NSObject

@property (nonatomic, strong, readonly) NSNumber *eId;
@property (nonatomic, weak, readonly) GGPoint *vertexA;
@property (nonatomic, weak, readonly) GGPoint *vertexB;
@property (nonatomic, readonly) NSInteger weight;

@end
