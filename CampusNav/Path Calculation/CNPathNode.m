//
//  CNPathNode.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPathNode.h"
#import "GGSystem.h"

NSString * CNPathNodeTypeText[kCNPathNodeTypeEnd] = {
	@"Start from", 
	@"Reach", 
	@"Go pass the", 
	@"Turn left at", 
	@"Turn right at", 
	@"Go up stairs", 
	@"Go down stairs"
};


@interface CNPathNode ()

@property (nonatomic, weak) GGPoint *previous;
@property (nonatomic, strong) GGPoint *current;
@property (nonatomic, weak) GGPoint *next;
@property (nonatomic) CNPathNodeType type;
@property (nonatomic) NSInteger distance;

@end

@implementation CNPathNode

#pragma mark - Getter & Setter
@synthesize previous = _previous;
@synthesize current = _current;
@synthesize next = _next;
@synthesize type = _type;
@synthesize distance = _distance;

- (NSString *)description
{
	NSString *prefix = nil;
	switch (self.type) {
		case kCNPathNodeTypeSource:
		case kCNPathNodeTypeDestination:
		case kCNPathNodeTypeStraight:
		case kCNPathNodeTypeLeft:
		case kCNPathNodeTypeRight:
			prefix = CNPathNodeTypeText[self.type];
			return [NSString stringWithFormat:@"%@ %@", prefix, self.current.description];
		case kCNPathNodeTypeUpStairs:
		case kCNPathNodeTypeDownStairs:
			return CNPathNodeTypeText[self.type];
		default:
			break;
	}
	return nil;
}

#pragma mark
+ (double)cornerTanFrom:(GGCoordinate)a 
				   pass:(GGCoordinate)b 
					 to:(GGCoordinate)c
{
	double denominatorBA = b.x - a.x;
	double denominatorCB = c.x - b.x;
	// Objective-c handle dividing by zero
	double kBA = (b.y - a.y) / denominatorBA;
	double kCB = (c.y - b.y) / denominatorCB;
	
	double denominatorTan = 1 - kBA * kCB;
	
	// Objective-c handle dividing by zero
	double tan = (kBA - kCB) / (1 - denominatorTan);
	return tan;
}

+ (double)cornerCosFrom:(GGCoordinate)a 
				   pass:(GGCoordinate)b 
					 to:(GGCoordinate)c
{
	double xAB = b.x - a.x;
	double yAB = b.y - a.y;
	
	double xBC = c.x - b.x;
	double yBC = c.y - b.y;
	
	// Objective-c handle dividing by zero
	double cos = (xAB * xBC + yAB * yBC) / 
	(sqrt(pow(xAB, 2) + pow(yAB, 2)) * 
	 sqrt(pow(xBC, 2) + pow(yBC, 2)));
	return cos;
}

+ (CNPathNode *)nodeAt:(GGPoint *)current 
		  withPrevious:(GGPoint *)previous 
			   andNext:(GGPoint *)next 
{
	CNPathNode *node = [[CNPathNode alloc] init];
	if (node != nil) {
		node.previous = previous;
		node.current = current;
		node.next = next;
		node.distance = [GGGraph weightBetweenCoordinate:previous.coordinate andCoordinate:current.coordinate];
		
		// If no previous, is source
		if (previous == nil) {
			node.type = kCNPathNodeTypeSource;
		}
		// If no next, is destination
		else if (next == nil) {
			node.type = kCNPathNodeTypeDestination;
		}
		// if is a portol, decide up/down stairs
		else if ([current isKindOfClass:[GGElement class]] && 
				 ((GGElement *)current).elementType == kGGPortal) {
			node.type = previous.floorPlan.floor > next.floorPlan.floor ? kCNPathNodeTypeDownStairs : kCNPathNodeTypeUpStairs;
		}
		// Else, is normal elements in between
		else {
			// Calculate tan
			double tan = [CNPathNode cornerTanFrom:previous.coordinate 
											  pass:current.coordinate 
												to:next.coordinate];
			// Calculate cos
			double cos = [CNPathNode cornerCosFrom:previous.coordinate 
											  pass:current.coordinate 
												to:next.coordinate];
			// If cos big enough, is going straight
			if (cos > 0.85) {
				node.type = kCNPathNodeTypeStraight;
			}
			else if (tan > 0) {
				if (cos > 0) {
					node.type = kCNPathNodeTypeLeft;
				}
				else {
					node.type = kCNPathNodeTypeRight;
				}
				
			}
			else {
				if (cos > 0) {
					node.type = kCNPathNodeTypeRight;
				}
				else {
					node.type = kCNPathNodeTypeLeft;
				}
			} // if
		} // if
	} // if
	return node;
}

@end
