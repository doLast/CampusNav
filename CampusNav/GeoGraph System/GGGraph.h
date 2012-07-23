//
//  GGGraph.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPOI;

@interface GGGraph : NSObject

@property (nonatomic, strong, readonly) NSDictionary *pointToEdges;

+ (GGGraph *)graphWithPointToEdges:(NSDictionary *)pointToEdges;

- (BOOL)insertPOI:(GGPOI *)poi;

@end
