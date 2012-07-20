//
//  UserPOI.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GGPOI;

@interface UserPOI : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSNumber * pId;
@property (nonatomic, weak, readonly) GGPOI * poi;
@property (nonatomic, retain) NSNumber * order;

@end
