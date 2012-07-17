//
//  GGSystem.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem.h"
#import "FMDatabase.h"

// Constants
static NSString * const kDataSourceName = @"GG_DATA";

// Private declarations
@interface GGSystem ()
@property (nonatomic, retain) FMDatabase *dataSource;

@end

// Implementations
@implementation GGSystem

#pragma mark - Getter & Setter
@synthesize dataSource = _dataSource;

#pragma mark - System Initialization
- (GGSystem *)initWithSqliteResource:(NSString *)resource
{
	self = [super init];
	if (self != nil) {
		// Initialize database connection
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resource 
																 ofType:@"sqlite"];
		FMDatabase *dataSource = [FMDatabase databaseWithPath:resourcePath];
		if (![dataSource open]) {
			NSLog(@"Failed to open data source at: %@", resourcePath);
			abort();
		}
		else {
			self.dataSource = dataSource;
		}
	}
	return self;
}

+ (GGSystem *)sharedGeoGraphSystem
{
	static GGSystem *system;
	if (system == nil) {
		system = [[GGSystem alloc] initWithSqliteResource:kDataSourceName];
	}
	return system;
}

#pragma mark - 

@end
