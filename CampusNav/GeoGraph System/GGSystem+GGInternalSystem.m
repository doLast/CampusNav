//
//  GGSystem+GGInternalSystem.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGSystem+GGInternalSystem.h"
#import "FMDatabase.h"

#import "GGFloorPlan.h"
#import "GGPoint.h"
#import "GGElement.h"
#import "GGPOI.h"
#import "GGEdge.h"
#import "GGGraph.h"


// Private declarations
@interface GGSystem ()
@property (nonatomic, strong, readonly) FMDatabase *dataSource;
@property (nonatomic, strong, readonly) NSMutableDictionary *buildingCache;
@property (nonatomic, strong, readonly) NSMutableDictionary *floorPlanCache;
@property (nonatomic, strong, readonly) NSMutableDictionary *pointCache;
@property (nonatomic, strong, readonly) NSMutableDictionary *edgeCache;

@end

@implementation GGSystem (GGInternalSystem)

- (GGBuilding *)getBuilding:(NSString *)name
{
	GGBuilding *building = [self.buildingCache objectForKey:name];
	if (building == nil) {
		building = [GGBuilding buildingWithName:@"Mathmetics & Computer" withAbbreviation:@"MC" atLocation:[[CLLocation alloc] initWithLatitude:43.472113 longitude:-80.543912]];
		NSLog(@"No cached building, fetched");
		
		[self.buildingCache setObject:building forKey:name];
	}
	return building;
}

- (GGFloorPlan *)getFloorPlan:(NSNumber *)fId
{
	GGFloorPlan *floorPlan = [self.floorPlanCache objectForKey:fId];
	if (floorPlan == nil) {
		// data source must be valid
		assert(self.dataSource);
		
		// Create result set and data container
		FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
								  @"SELECT * FROM floor_plan AS f \
								  WHERE f.f_id = %@ \
								  ORDER BY f.floor ASC;", fId];		
		// Build data
		if ([resultSet next]) {
			NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"f_id"]];
			floorPlan = [GGFloorPlan 
						 floorPlanWithFid:fId
						 inBuilding:[resultSet stringForColumn:@"building"] 
						 onFloor:[resultSet intForColumn:@"floor"]];
		}
		NSLog(@"No cached floor plan, fetched");
		
		[self.floorPlanCache setObject:floorPlan forKey:fId];
	}
	return floorPlan;
}

- (GGEdge *)getEdge:(NSNumber *)eId
{
//	GGEdge *edge = [self.edgeCache objectForKey:eId];
//	if (edge == nil) {
		// data source must be valid
		assert(self.dataSource);
		
		// Create result set and data container
		FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
								  @"SELECT * FROM edge as e \
								  WHERE e.e_id = %@;", eId];
		
		if ([resultSet next]) {
//			NSNumber *eId = [NSNumber numberWithInt:[resultSet intForColumn:@"e_id"]];
			NSNumber *vertexA = [NSNumber numberWithInt:[resultSet intForColumn:@"vertex_A"]];
			NSNumber *vertexB = [NSNumber numberWithInt:[resultSet intForColumn:@"vertex_B"]];
			NSInteger weight = [resultSet intForColumn:@"weight"];
			
			GGEdge *edge = [GGEdge edgeWithEId:eId 
								 connectsPoint:vertexA 
									  andPoint:vertexB 
									haveWeight:weight];
			return edge;
		}
		
		return nil;
//	}
}

- (GGPoint *)getPoint:(NSNumber *)pId
{
	return [self.pointCache objectForKey:pId];
}

- (GGElement *)getElement:(NSNumber *)pId
{
	GGElement *point = [self.pointCache objectForKey:pId];
	if ([point isKindOfClass:[GGElement class]]) {
		return point;
	}
	return nil;
}

- (GGPOI *)getPOI:(NSNumber *)pId
{
	GGPOI *point = [self.pointCache objectForKey:pId];
	if (point == nil) {
		// data source must be valid
		assert(self.dataSource);
		
		// Create result set and data container
		FMResultSet *resultSet = [self.dataSource executeQueryWithFormat:
								  @"SELECT p.p_id, p.floor_plan, p.x, p.y, \
								  i.room_number, i.category, i.edge \
								  FROM point AS p, point_poi AS i  \
								  WHERE p.p_id = %@ \
								  AND i.p_id = p.p_id;", pId];
		
		// Build data
		if ([resultSet next]) {
			NSNumber *pId = [NSNumber numberWithInt:[resultSet intForColumn:@"p_id"]];
			NSNumber *fId = [NSNumber numberWithInt:[resultSet intForColumn:@"floor_plan"]];
			GGCoordinate coordinate = [GGPoint coordinateAtX:[resultSet intForColumn:@"x"]
														andY:[resultSet intForColumn:@"y"]];
			GGPOICategory category = [GGPOI categoryOfAbbreviation:
									  [resultSet stringForColumn:@"category"]];
			NSNumber *eId = [NSNumber numberWithInt:[resultSet intForColumn:@"edge"]];
			NSString *roomNum = [resultSet stringForColumn:@"room_number"];
			NSString *description = nil; // [resultSet stringForColumn:@"description"];
			
			point = [GGPOI poiWithPId:pId 
							  onFloor:fId 
						 atCoordinate:coordinate 
					   withinCategory:category 
							   onEdge:eId 
						  withRoomNum:roomNum 
					   andDescription:description];
		}
		
		NSLog(@"No cached POI, fetched");
		
		[self.pointCache setObject:point forKey:pId];
	}
	if ([point isKindOfClass:[GGPOI class]]) {
		return point;
	}
	return nil;
}

@end
