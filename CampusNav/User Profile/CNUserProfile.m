//
//  CNUserProfile.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNUserProfile.h"
#import "UserPOI.h"

@interface CNUserProfile ()

@property (nonatomic, strong) NSArray *userPOIs;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end

@implementation CNUserProfile

#pragma mark - Getter & Setter
@synthesize userPOIs = _userPOIs;
@synthesize managedObjectContext = _managedObjectContext;

- (CNUserProfile *)init
{
	self = [super init];
	if (self != nil) {
		self.userPOIs = nil;
		
		self.managedObjectContext = [(id) [[UIApplication sharedApplication] delegate] managedObjectContext];
		[self updateUserPOIs];
	}
	return self;
}

+ (CNUserProfile *)sharedUserProfile
{
	static CNUserProfile *userProfile;
	if (userProfile == nil) {
		userProfile = [[CNUserProfile alloc] init];
	}
	return userProfile;
}

- (void)updateUserPOIs
{
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserPOI"];
	
	NSError *error = nil;
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (array == nil) {
		// Deal with error
		NSLog(@"Fail to fetch UserPOIs, error: %@", error);
		array = [NSArray array];
	}
	
	self.userPOIs = array;
}

#pragma mark - Public methods
- (UserPOI *)userPOIbyId:(NSNumber *)pId
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pId = %@", pId];
	NSArray *result = [self.userPOIs filteredArrayUsingPredicate:predicate];
	
	if ([result count] > 1) {
		NSLog(@"Got multiple user POI match pId: %@", pId);
	}
	if ([result count] > 0) {
		return [result objectAtIndex:0];
	}
	return nil;
}

- (BOOL)addPOI:(NSNumber *)pId withDisplayName:(NSString *)displayName
{
	UserPOI *userPOI = [self userPOIbyId:pId];
	if (userPOI != nil) {
		return [self changeUserPOI:userPOI withDisplayName:displayName];
	}
	
	userPOI = (UserPOI *) [NSEntityDescription 
						   insertNewObjectForEntityForName:@"UserPOI" 
						   inManagedObjectContext:self.managedObjectContext];
	userPOI.pId = pId;
	userPOI.displayName = displayName;
	userPOI.order = [NSNumber numberWithUnsignedInteger:[self.userPOIs count]];
	
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// Deal with error
		NSLog(@"Fail to add UserPOIs, error: %@", error);
		[self removeUserPOI:userPOI];
		return NO;
	}
	
	NSLog(@"Added pId:%@ name:%@ to user profile", pId, displayName);
	[self updateUserPOIs];
	
	return YES;
}

- (BOOL)removePOI:(NSNumber *)pId
{
	UserPOI *userPOI = [self userPOIbyId:pId];
	if (userPOI != nil) {
		return [self removeUserPOI:userPOI];
	}
	return NO;
}

- (BOOL)removeUserPOI:(UserPOI *)userPOI
{
	[self.managedObjectContext deleteObject:userPOI];
	
	NSLog(@"Removed user POI from user profile");
	[self updateUserPOIs];
	return YES;
}

- (BOOL)changeUserPOI:(UserPOI *)userPOI withDisplayName:(NSString *)displayName
{
	userPOI.displayName = displayName;
	
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// Deal with error
		NSLog(@"Fail to change UserPOI displayName, error: %@", error);
		return NO;
	}
	
	NSLog(@"Changed display name for user POI:%@ in user profile", userPOI.pId);
	[self updateUserPOIs];
	return YES;
}

@end
