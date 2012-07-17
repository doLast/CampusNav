//
//  GGSystem.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem.h"
#import "FMDatabase.h"

#import "GGFloorPlan.h"
#import "GGPoint.h"
#import "GGElement.h"
#import "GGPOI.h"
#import "GGEdge.h"
#import "GGGraph.h"

// Constants
static NSString * const kDataSourceName = @"GG_DATA";

// Private declarations
@interface GGSystem ()
@property (nonatomic, strong) FMDatabase *dataSource;
@property (nonatomic, strong) NSMutableDictionary *floorPlanCache;
@property (nonatomic, strong) NSMutableDictionary *pointCache;
@property (nonatomic, strong) NSMutableDictionary *edgeCache;

@end

// Implementations
@implementation GGSystem

#pragma mark - Getter & Setter
@synthesize dataSource = _dataSource;
@synthesize floorPlanCache = _floorPlanCache;
@synthesize pointCache = _pointCache;
@synthesize edgeCache = _edgeCache;

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
		
		// Initialize the cache containers
		self.floorPlanCache = [NSMutableDictionary dictionary];
		self.pointCache = [NSMutableDictionary dictionary];
		self.edgeCache = [NSMutableDictionary dictionary]; 
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

- (NSArray *)floorPlansOfBuilding:(NSString *)building
{
	// Get floor plans from cache if exists
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"building = %@", building];
	NSArray *filtered = [[self.floorPlanCache allValues] 
						 filteredArrayUsingPredicate:predicate];
	if (filtered.count > 0) {
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor 
											sortDescriptorWithKey:@"floor" ascending:YES];
		NSArray *sorted = [filtered sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:sortDescriptor]];
		NSLog(@"Found %d floor plans from cache", sorted.count);
		return sorted;
	}
	
	// Otherwise, get from data source
	// data source must be valid
	assert(self.dataSource);
	
	// Create result set and data container
	FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
							  @"SELECT * FROM floor_plan AS f \
							  WHERE f.building = %@ \
							  ORDER BY f.floor ASC;", building];
	NSMutableArray *floorPlans = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		GGFloorPlan *floorPlan = [GGFloorPlan 
								  floorPlanWithFid:[NSNumber numberWithInt:[resultSet intForColumn:@"f_id"]]
								  inBuilding:[resultSet stringForColumn:@"building"] 
								  onFloor:[resultSet intForColumn:@"floor"] 
								  atLocation:nil 
								  withAbbreviation:[resultSet stringForColumn:@"abbr"]];
		// TODO Add location
		[floorPlans addObject:floorPlan];
		[self.floorPlanCache setObject:floorPlan forKey:floorPlan.fId];
	}
	
	NSLog(@"Found %d floor plans from data source", floorPlans.count);
	return floorPlans;
}

- (NSArray *)poisInBuilding:(NSString *)building
{
	// Get floor plans for the building
	NSArray *floorPlans = [self floorPlansOfBuilding:building];
	NSMutableArray *pois = [NSMutableArray array];
	
	for (GGFloorPlan *floorPlan in floorPlans) {
		[pois addObjectsFromArray:[self poisOnFloorPlan:floorPlan]];
	}
	
	return pois;
}

- (NSArray *)poisOnFloorPlan:(GGFloorPlan *)floorPlan
{
	// Get pois from cache if exists
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"SELF isKindOfClass:%@ && floorPlan = %@", [GGPOI class], floorPlan];
	NSArray *filtered = [[self.pointCache allValues] 
						 filteredArrayUsingPredicate:predicate];
	if (filtered.count > 0) {
		NSLog(@"Found %d POIs from cache", filtered.count);
		return filtered;
	}
	
	// Otherwise, get from data source
	// data source must be valid
	assert(self.dataSource);
	
	// Create result set and data container
	FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
							  @"SELECT p.p_id, p.floor_plan, p.x, p.y, \
							  i.room_number, i.category, i.edge \
							  FROM point AS p, point_poi AS i  \
							  WHERE p.floor_plan = %@ \
							  AND i.p_id = p.p_id;", floorPlan.fId];
	NSMutableArray *pois = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		NSNumber *pId = [NSNumber numberWithInt:[resultSet intForColumn:@"p_id"]];
		NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"floor_plan"]];
		GGCoordinate coordinate = [GGPoint coordinateAtX:[resultSet intForColumn:@"x"]
													andY:[resultSet intForColumn:@"y"]];
		GGPOICategory category = [GGPOI categoryOfAbbreviation:
								  [resultSet stringForColumn:@"category"]];
		NSNumber *eId = [NSNumber numberWithInt:[resultSet intForColumn:@"edge"]];
		NSString *roomNum = [resultSet stringForColumn:@"room_number"];
		NSString *description = nil; // [resultSet stringForColumn:@"description"];
		
		GGPOI *poi = [GGPOI poiWithPId:pId 
							   onFloor:fId 
						  atCoordinate:coordinate 
						withinCategory:category 
								onEdge:eId 
						   withRoomNum:roomNum 
						andDescription:description];
		
		[pois addObject:poi];
		[self.pointCache setObject:poi forKey:poi.pId];
	}
	
	NSLog(@"Found %d POIs from data source", pois.count);
	return pois;
}

- (GGGraph *)graphOfFloorPlan:(GGFloorPlan *)floorPlan
{
	return nil;
}

- (GGGraph *)graphFrom:(GGPoint *)source to:(GGPoint *)destination
{
	return nil;
}

@end
