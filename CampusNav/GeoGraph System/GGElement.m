//
//  GGElement.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGElement.h"

@interface GGElement ()

@property (nonatomic) NSNumber *pId;
@property (nonatomic, strong) NSNumber * fId;
@property (nonatomic) GGCoordinate coordinate;

@property (nonatomic) GGElementType elementType;

@end

@implementation GGElement

#pragma mark - Getter & Setter
@synthesize pId = _pId;
@synthesize fId = _fId;
@synthesize coordinate = _coordinate;

@synthesize elementType = _elementType;

#pragma mark - Convenicent Constructor
+ (GGElement *)elementWithPId:(NSNumber *)pId 
					  onFloor:(NSNumber *)fId 
				 atCoordinate:(GGCoordinate)coordinate 
					   isType:(GGElementType)elementType
{
	GGElement *element = [[GGElement alloc] init];
	element.pId = pId;
	element.fId = fId;
	element.coordinate = coordinate;
	element.elementType = elementType;
	return element;
}

@end
