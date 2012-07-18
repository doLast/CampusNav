//
//  GGPOI.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPoint.h"

typedef enum {
	kGGWomanWashroom = 0,
	kGGManWashroom, 
	kGGElevator, 
	kGGClassroom, 
	kGGCommonRoom, 
	kGGOffice, 
	kGGLab, 
	kGGPrinter, 
	kGGSecret, 
	kGGPOICategoryEnd
} GGPOICategory;

extern NSString *GGPOICategoryNames[kGGPOICategoryEnd];
extern NSString *GGPOICategoryAbbreviations[kGGPOICategoryEnd];

@class GGEdge;

@interface GGPOI : GGPoint

@property (nonatomic, readonly) GGPOICategory category;
@property (nonatomic, weak, readonly) GGEdge *edge;
@property (nonatomic, strong, readonly) NSString *roomNum;
@property (nonatomic, strong, readonly) NSString *description;

+ (GGPOI *)poiWithPId:(NSNumber *)pId 
			  onFloor:(NSNumber *)fId 
		 atCoordinate:(GGCoordinate)coordinate 
	   withinCategory:(GGPOICategory)category 
			   onEdge:(NSNumber *)eId 
		  withRoomNum:(NSString *)roomNum 
	   andDescription:(NSString *)description;

+ (GGPOICategory)categoryOfAbbreviation:(NSString *)abbr;

@end
