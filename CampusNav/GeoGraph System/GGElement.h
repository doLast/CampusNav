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

extern NSString *GGElementTypeText[kGGElementTypeEnd];

@interface GGElement : GGPoint

@property (nonatomic, readonly) GGElementType elementType;

+ (GGElement *)elementWithPId:(NSNumber *)pId 
					  onFloor:(NSNumber *)fId 
				 atCoordinate:(GGCoordinate)coordinate 
					   isType:(GGElementType)elementType;
+ (GGElement *)elementWithPId:(NSNumber *)pId;

+ (GGElementType)elementTypeOfText:(NSString *)text;


@end
