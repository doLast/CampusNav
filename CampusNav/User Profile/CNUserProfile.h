//
//  CNUserProfile.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPOI.h"

@interface CNUserProfile : NSObject

@property (nonatomic, strong, readonly) NSArray *userPOIs;

+ (CNUserProfile *)sharedUserProfile;

- (UserPOI *)userPOIbyId:(NSNumber *)pId;
- (BOOL)addPOI:(NSNumber *)pId withDisplayName:(NSString *)displayName;
- (BOOL)removePOI:(NSNumber *)pId;
- (BOOL)removeUserPOI:(UserPOI *)userPOI;
- (BOOL)changeUserPOI:(UserPOI *)userPOI withDisplayName:(NSString *)displayName;

@end
