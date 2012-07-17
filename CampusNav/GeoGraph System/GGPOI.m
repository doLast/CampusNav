//
//  GGPOI.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPOI.h"

static NSString *GGPOICategoryAbbreviations[kGGPOICategoryEnd] = {
	@"W", 
	@"M", 
	@"E", 
	@"C", 
	@"N", 
	@"O", 
	@"L", 
	@"P", 
	@"X", 
};

@interface GGPOI ()

@property (nonatomic, assign) NSInteger pId;
@property (nonatomic, assign) GGCoordinate coordinate;
@property (nonatomic, assign) GGPOICategory category;
@property (nonatomic, retain) GGEdge *edge;
@property (nonatomic, retain) NSString *roomNum;
@property (nonatomic, retain) NSString *description;


@end

@implementation GGPOI

@synthesize pId = _pId;
@synthesize coordinate = _coordinate;
@synthesize category = _category;
@synthesize edge = _edge;
@synthesize roomNum = _roomNum;
@synthesize description = _description;

@end
