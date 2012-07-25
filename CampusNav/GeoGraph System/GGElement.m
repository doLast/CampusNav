//
//  GGElement.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGElement.h"
#import "GGSystem+GGInternalSystem.h"

NSString *GGElementTypeText[kGGElementTypeEnd] = {
	@"node", 
	@"portal", 
	@"corner", 
	@"intersection", 
	@"exit"
};

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

+ (GGElement *)elementWithPId:(NSNumber *)pId
{
	return [[GGSystem sharedGeoGraphSystem] getElement:pId];
}

+ (GGElementType)elementTypeOfText:(NSString *)text
{
	NSArray *array = [NSArray arrayWithObjects:GGElementTypeText count:kGGElementTypeEnd];
	return [array indexOfObject:text];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ #%@", GGElementTypeText[self.elementType], self.pId];
}

@end
