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

static NSString *GGPOICategoryNames[kGGPOICategoryEnd] = {
	@"Woman's Washroom", 
	@"Man's Washroom", 
	@"Elevator", 
	@"Classroom", 
	@"Common Room", 
	@"Office", 
	@"Lab", 
	@"Printer", 
	@"Secret", 
};

@class GGEdge;

@interface GGPOI : GGPoint

@property (nonatomic, assign, readonly) GGPOICategory category;
@property (nonatomic, retain, readonly) GGEdge *edge;
@property (nonatomic, retain, readonly) NSString *roomNum;
@property (nonatomic, retain, readonly) NSString *description;

@end
