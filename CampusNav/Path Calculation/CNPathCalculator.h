//
//  CNPathCalculator.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGGraph;
@class GGPoint;
@class GGPOI;

@interface CNPathCalculator : NSObject

@property (nonatomic, strong, readonly) GGPOI *source;
@property (nonatomic, strong, readonly) GGPOI *destination;

- (CNPathCalculator *)initFromPOI:(GGPOI *)source 
							toPOI:(GGPOI *)destination;

// Start calculation and return result
- (NSArray *)executeCalculation;

+ (NSDictionary *)dijkstraWithGraph:(GGGraph *)graph 
						 fromSource:(GGPoint *)source 
					  toDestination:(GGPoint *)destination;

@end
