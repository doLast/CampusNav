//
//  GGElement.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGElement.h"

@interface GGElement ()

@property (nonatomic, assign) NSInteger pId;
@property (nonatomic, assign) GGCoordinate coordinate;
@property (assign, nonatomic) GGElementType elementType;

@end

@implementation GGElement

@synthesize pId = _pId;
@synthesize coordinate = _coordinate;
@synthesize elementType = _elementType;


@end
