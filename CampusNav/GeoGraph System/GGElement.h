//
//  GGElement.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPoint.h"

typedef enum {
	kGGNode = 0, 
	kGGPortal,
	kGGElementTypeEnd
} GGElementType;

@interface GGElement : GGPoint

@property (assign, nonatomic, readonly) GGElementType elementType;

@end
