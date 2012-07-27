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
// We do not cache edges because they are only used in graph generation

@property (nonatomic, strong) NSMutableSet *buildingCacheIndicator;
@property (nonatomic, strong) NSMutableSet *floorCacheIndicator;
@property (nonatomic, strong) NSMutableSet *poiCacheIndicator;
@property (nonatomic, strong) NSMutableSet *elementCacheIndicator;

@end

// Implementations
@implementation GGSystem

#pragma mark - Getter & Setter
@synthesize dataSource = _dataSource;
@synthesize buildingCache = _buildingCache;
@synthesize floorPlanCache = _floorPlanCache;
@synthesize pointCache = _pointCache;

@synthesize buildingCacheIndicator = _buildingCacheIndicator;
@synthesize floorCacheIndicator = _floorCacheIndicator;
@synthesize poiCacheIndicator = _poiCacheIndicator;
@synthesize elementCacheIndicator = _elementCacheIndicator;

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
			// If cannot locate the database, we can do nothing, just abort.
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
		
		self.buildingCacheIndicator = [NSMutableSet set];
		self.floorCacheIndicator = [NSMutableSet set];
		self.poiCacheIndicator = [NSMutableSet set];
		self.elementCacheIndicator = [NSMutableSet set];
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

#pragma mark - Building
- (NSArray *)buildingsInCampus:(NSString *)campus
{
	// Currently, campus does not do anything
	
	// Get buildings from cache if exists
	if ([self.buildingCacheIndicator containsObject:campus]) {
		return [self.buildingCache allValues];
	}
	
	// Otherwise, get from data source
	// data source must be valid
	assert(self.dataSource);
	
	// Create result set and data container
	FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
							  @"SELECT * FROM building AS b;"];
	NSMutableArray *buildings = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		NSNumber *bId = [NSNumber numberWithInt:[resultSet intForColumn:@"b_id"]];
		CLLocation *location = [[CLLocation alloc] 
								initWithLatitude:[resultSet doubleForColumn:@"latitude"] 
								longitude:[resultSet doubleForColumn:@"longitude"]];
		GGBuilding *building = [GGBuilding buildingWithBId:bId 
												  withName:[resultSet stringForColumn:@"name"] 
										  withAbbreviation:[resultSet stringForColumn:@"abbr"] 
												atLocation:location];
		[buildings addObject:building];
		[self.buildingCache setObject:building forKey:building.bId];
	}
	
	// Add current building to cache indicator
	[self.buildingCacheIndicator addObject:campus];
	
	NSLog(@"Found %d buildings from data source", [buildings count]);
	return buildings;
}

#pragma mark - FloorPlans
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
	if ([self.floorCacheIndicator containsObject:building.bId]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"building.bId = %@", building.bId];
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
							  ORDER BY f.floor ASC;", building.bId];
	NSMutableArray *floorPlans = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"f_id"]];
		NSNumber *bId = [NSNumber numberWithInt:[resultSet intForColumn:@"building"]];
		GGFloorPlan *floorPlan = [GGFloorPlan 
								  floorPlanWithFid:fId 
								  inBuilding:bId
								  onFloor:[resultSet intForColumn:@"floor"] 
								  withDescription:[resultSet stringForColumn:@"description"]];
		[floorPlans addObject:floorPlan];
		[self.floorPlanCache setObject:floorPlan forKey:floorPlan.fId];
	}
	
	// Add current building to cache indicator
	[self.floorCacheIndicator addObject:building.bId];
	
	NSLog(@"Found %d floor plans from data source", [floorPlans count]);
	return floorPlans;
}

#pragma mark - POIs
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
							  i.room_number, i.category, i.edge, i.description \
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
		NSString *description = [resultSet stringForColumn:@"description"];
		
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

#pragma mark - Elements

- (NSArray *)elementsOnFloorPlan:(GGFloorPlan *)floorPlan
{
	// Get pois from cache if exists
	if ([self.elementCacheIndicator containsObject:floorPlan.fId]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"SELF isKindOfClass:%@ && floorPlan.fId = %@", 
								  [GGElement class], floorPlan.fId];
		NSArray *filtered = [[self.pointCache allValues] 
							 filteredArrayUsingPredicate:predicate];
		NSLog(@"Found %d Elements from cache", filtered.count);
		return filtered;
	}
	
	// Otherwise, get from data source
	// data source must be valid
	assert(self.dataSource);
	
	// Create result set and data container
	FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
							  @"SELECT p.p_id, p.floor_plan, p.x, p.y, \
							  t.e_type \
							  FROM point AS p, point_element AS t  \
							  WHERE p.floor_plan = %@ \
							  AND t.p_id = p.p_id;", floorPlan.fId];
	NSMutableArray *elements = [NSMutableArray array];
	
	// Build data
	while ([resultSet next]) {
		NSNumber *pId = [NSNumber numberWithInt:[resultSet intForColumn:@"p_id"]];
		NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"floor_plan"]];
		GGCoordinate coordinate = [GGPoint coordinateAtX:[resultSet intForColumn:@"x"]
													andY:[resultSet intForColumn:@"y"]];
		GGElementType eType = [GGElement elementTypeOfText:
								  [resultSet stringForColumn:@"e_type"]];
		
		GGElement *element = [GGElement elementWithPId:pId 
											   onFloor:fId 
										  atCoordinate:coordinate 
												isType:eType];
		
		[elements addObject:element];
		[self.pointCache setObject:element forKey:element.pId];
	}
	
	// Add current floor plan to cache indicator
	[self.elementCacheIndicator addObject:floorPlan.fId];
	
	NSLog(@"Found %d Elements from data source", elements.count);
	return elements;
}

#pragma mark - Graph Generation
- (GGGraph *)graphOfFloorPlan:(GGFloorPlan *)floorPlan
{
	// Pre-fetch POIs and Elements of the floorPlan
//	if (![self.poiCacheIndicator containsObject:floorPlan.fId]) {
//		[self poisOnFloorPlan:floorPlan];
//	}
	NSArray *elements = [self elementsOnFloorPlan:floorPlan];
		
	NSMutableDictionary *pointToEdges = 
	[NSMutableDictionary dictionaryWithCapacity:[elements count]];
	
	for (GGElement *element in elements) {
		FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
								  @"SELECT * FROM edge as e \
								  WHERE e.vertex_A = %@ \
								  OR e.vertex_B = %@;", 
								  element.pId, element.pId];
		NSMutableSet *edges = [NSMutableSet set];
		
		while ([resultSet next]) {
			NSNumber *eId = [NSNumber numberWithInt:[resultSet intForColumn:@"e_id"]];
			NSNumber *vertexA = [NSNumber numberWithInt:[resultSet intForColumn:@"vertex_A"]];
			NSNumber *vertexB = [NSNumber numberWithInt:[resultSet intForColumn:@"vertex_B"]];
			NSInteger weight = [resultSet intForColumn:@"weight"];
			
			GGEdge *edge = [GGEdge edgeWithEId:eId 
								 connectsPoint:vertexA 
									  andPoint:vertexB 
									haveWeight:weight];
			[edges addObject:edge];
		}
		
		[pointToEdges setObject:edges forKey:element.pId];
	}
	
	GGGraph *graph = [GGGraph graphWithPointToEdges:pointToEdges];
	return graph;
}

@end
