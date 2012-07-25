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

#pragma mark
+ (double)cornerTanFrom:(GGCoordinate)a 
				   pass:(GGCoordinate)b 
					 to:(GGCoordinate)c
{
	double denominatorBA = b.x - a.x;
	double denominatorCB = c.x - b.x;
	// Check zero
	double kBA = (b.y - a.y) / denominatorBA;
	double kCB = (c.y - b.y) / denominatorCB;
	
	double denominatorTan = 1 - kBA * kCB;
	// Check zero
	
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
		
		if (previous == nil) {
			node.type = kCNPathNodeTypeSource;
		}
		else if (next == nil) {
			node.type = kCNPathNodeTypeDestination;
		}
		else if ([current isKindOfClass:[GGElement class]] && 
				 ((GGElement *)current).elementType == kGGPortal) {
			node.type = previous.floorPlan.floor > next.floorPlan.floor ? kCNPathNodeTypeDownStairs : kCNPathNodeTypeUpStairs;
		}
		else {
			double tan = [CNPathNode cornerTanFrom:previous.coordinate 
											  pass:current.coordinate 
												to:next.coordinate];
			double cos = [CNPathNode cornerCosFrom:previous.coordinate 
											  pass:current.coordinate 
												to:next.coordinate];
			if (fabs(tan) < 0.6) {
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
			}
		}
	}
	return node;
}

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

@end
