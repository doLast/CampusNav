//
//  CNPathNode.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kCNPathNodeTypeSource = 0, 
	kCNPathNodeTypeDestination, 
	kCNPathNodeTypeStraight, 
	kCNPathNodeTypeLeft, 
	kCNPathNodeTypeRight, 
	kCNPathNodeTypeUpStairs, 
	kCNPathNodeTypeDownStairs, 
	kCNPathNodeTypeEnd
} CNPathNodeType;

extern NSString * CNPathNodeTypeText[kCNPathNodeTypeEnd];

@class GGPoint;

@interface CNPathNode : NSObject

@property (nonatomic, weak, readonly) GGPoint *previous;
@property (nonatomic, strong, readonly) GGPoint *current;
@property (nonatomic, weak, readonly) GGPoint *next;
@property (nonatomic, readonly) CNPathNodeType type;
@property (nonatomic, readonly) NSInteger distance;

+ (CNPathNode *)nodeAt:(GGPoint *)current 
		  withPrevious:(GGPoint *)previous 
			   andNext:(GGPoint *)next;

@end
