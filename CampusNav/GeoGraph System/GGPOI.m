//
//  GGPOI.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGPOI.h"
#import "GGSystem+GGInternalSystem.h"

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

@property (nonatomic, strong) NSNumber *pId;
@property (nonatomic, strong) NSNumber *fId;
@property (nonatomic) GGCoordinate coordinate;

@property (nonatomic) GGPOICategory category;
@property (nonatomic, strong) NSNumber *eId;
@property (nonatomic, strong) NSString *roomNum;
@property (nonatomic, strong) NSString *description;


@end

@implementation GGPOI

#pragma mark - setter & getter
@synthesize pId = _pId;
@synthesize coordinate = _coordinate;
@synthesize fId = _fId;

@synthesize category = _category;
@synthesize eId = _eId;
@synthesize roomNum = _roomNum;
@synthesize description = _description;

- (GGEdge *)edge
{
	return [[GGSystem sharedGeoGraphSystem] getEdge:self.eId];
}

#pragma mark - Convenivent Constructor
+ (GGPOI *)poiWithPId:(NSNumber *)pId 
			  onFloor:(NSNumber *)fId 
		 atCoordinate:(GGCoordinate)coordinate 
	   withinCategory:(GGPOICategory)category 
			   onEdge:(NSNumber *)eId 
		  withRoomNum:(NSString *)roomNum 
	   andDescription:(NSString *)description
{
	GGPOI *poi = [[GGPOI alloc] init];
	poi.pId = pId;
	poi.fId = fId;
	poi.coordinate = coordinate;
	poi.category = category;
	poi.eId = eId;
	poi.roomNum = roomNum;
	poi.description = description;
	return poi;
}

+ (GGPOICategory)categoryOfAbbreviation:(NSString *)abbr
{
	NSArray *array = [NSArray arrayWithObjects:GGPOICategoryAbbreviations count:kGGPOICategoryEnd];
	return [array indexOfObject:abbr];
}

@end
