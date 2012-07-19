//
//  GGSystem.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem.h"
#import "FMDatabase.h"

#import "GGBuilding.h"
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
@property (nonatomic, strong) NSMutableDictionary *buildingCache;
@property (nonatomic, strong) NSMutableDictionary *floorPlanCache;
@property (nonatomic, strong) NSMutableDictionary *pointCache;
//@property (nonatomic, strong) NSMutableDictionary *edgeCache;

@property (nonatomic, strong) NSMutableSet *buildingCacheIndicator;
@property (nonatomic, strong) NSMutableSet *floorCacheIndicator;
@property (nonatomic, strong) NSMutableSet *poiCacheIndicator;
//@property (nonatomic, strong) NSMutableSet *edgeCacheIndicator;

@end

// Implementations
@implementation GGSystem

#pragma mark - Getter & Setter
@synthesize dataSource = _dataSource;

@synthesize buildingCache = _buildingCache;
@synthesize floorPlanCache = _floorPlanCache;
@synthesize pointCache = _pointCache;
//@synthesize edgeCache = _edgeCache;

@synthesize buildingCacheIndicator = _buildingCacheIndicator;
@synthesize floorCacheIndicator = _floorCacheIndicator;
@synthesize poiCacheIndicator = _poiCacheIndicator;
//@synthesize edgeCacheIndicator = _edgeCacheIndicator;

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
		self.buildingCache = [NSMutableDictionary dictionary];
		self.floorPlanCache = [NSMutableDictionary dictionary];
		self.pointCache = [NSMutableDictionary dictionary];
//		self.edgeCache = [NSMutableDictionary dictionary]; 
		
		self.buildingCacheIndicator = [NSMutableSet set];
		self.floorCacheIndicator = [NSMutableSet set];
		self.poiCacheIndicator = [NSMutableSet set];
//		self.edgeCacheIndicator = [NSMutableSet set];
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

#pragma mark - Data fetching methods

//- (void) executeQuery:(NSString *)query 
//		withArguments:(NSArray *)arguments 
//  andSaveEachByMethod:(SEL)method
//{
//	// data source must be valid
//	assert(self.dataSource);
//	
//	// Create result set and data container
//	FMResultSet *resultSet = [self.dataSource executeQuery:query withArgumentsInArray:arguments];
//	
//	// Build data
//	while ([resultSet next]) {
//		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:method]];
//		invocation.target = self;
//		invocation.selector = method;
//		[invocation setArgument:&resultSet atIndex:0];
//		[invocation invoke];
//	}
//}

// Buildings
- (NSArray *)buildingsInCampus:(NSString *)campus
{
	// Currently, campus does not do anything
	
	// Get buildings from cache if exists
	if ([self.buildingCache count] > 0) {
		return [self.buildingCache allValues];
	}
	
	GGBuilding *building = [GGBuilding buildingWithName:@"Mathmetics & Computer" withAbbreviation:@"MC" atLocation:[[CLLocation alloc] initWithLatitude:43.472113 longitude:-80.543912]];
	[self.buildingCache setObject:building forKey:building.name];
	NSArray *buildings = [NSArray arrayWithObject:building];
	
	[self.buildingCacheIndicator addObject:campus];
	return buildings;
}

// FloorPlans
- (NSArray *)floorPlansOfCampus:(NSString *)campus
{
	// Get buildings in the campus
	NSArray *buildings = [self buildingsInCampus:campus];
	NSMutableArray *floorPlans = [NSMutableArray array];
	
	for (GGBuilding *building in buildings) {
		[floorPlans addObjectsFromArray:[self floorPlansOfBuilding:building]];
	}
	
	return floorPlans;
}

- (NSArray *)floorPlansOfBuilding:(GGBuilding *)building
{
	// Get floor plans from cache if exists
	if ([self.floorCacheIndicator containsObject:building.name]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"building.name = %@", building.name];
		NSArray *filtered = [[self.floorPlanCache allValues] 
							 filteredArrayUsingPredicate:predicate];
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor 
											sortDescriptorWithKey:@"floor" ascending:YES];
		NSArray *sorted = [filtered sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:sortDescriptor]];
		NSLog(@"Found %d floor plans from cache", [sorted count]);
		return sorted;
	}
	
	// Otherwise, get from data source
	// data source must be valid
	assert(self.dataSource);
	
	// Create result set and data container
	FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
							  @"SELECT * FROM floor_plan AS f \
							  WHERE f.building = %@ \
							  ORDER BY f.floor ASC;", building.name];
	NSMutableArray *floorPlans = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"f_id"]];
		GGFloorPlan *floorPlan = [GGFloorPlan 
								  floorPlanWithFid:fId
								  inBuilding:[resultSet stringForColumn:@"building"] 
								  onFloor:[resultSet intForColumn:@"floor"]];
		[floorPlans addObject:floorPlan];
		[self.floorPlanCache setObject:floorPlan forKey:floorPlan.fId];
	}
	
	// Add current building to cache indicator
	[self.floorCacheIndicator addObject:building.name];
	
	NSLog(@"Found %d floor plans from data source", [floorPlans count]);
	return floorPlans;
}

// POIs
- (NSArray *)poisInBuilding:(GGBuilding *)building
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
	if ([self.poiCacheIndicator containsObject:floorPlan.fId]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"SELF isKindOfClass:%@ && floorPlan.fId = %@", 
								  [GGPOI class], floorPlan.fId];
		NSArray *filtered = [[self.pointCache allValues] 
							 filteredArrayUsingPredicate:predicate];
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
	
	// Add current floor plan to cache indicator
	[self.poiCacheIndicator addObject:floorPlan.fId];
	
	NSLog(@"Found %d POIs from data source", pois.count);
	return pois;
}

// Graph Generation
- (GGGraph *)graphOfFloorPlan:(GGFloorPlan *)floorPlan
{
	return nil;
}

- (GGGraph *)graphFrom:(GGPoint *)source to:(GGPoint *)destination
{
	return nil;
}

@end
