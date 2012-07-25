//
//  CNPOICell.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNPOICell.h"
#import "GGSystem.h"

@implementation CNPOICell

#pragma mark - Getter & Setter
@synthesize roomNumber = _roomNumber;
@synthesize roomDescription = _roomDescription;
@synthesize buildingName = _buildingName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithPOI:(GGPOI *)poi
{
	if (poi == nil) {
		[self clearCellWithPrompt:@"Please choose one"];
		return;
	}
	if (self.roomNumber != nil) {
		NSString *roomNumber = [NSString stringWithFormat:@"%@ %@", 
								poi.floorPlan.building.abbreviation, 
								poi.roomNum];
		self.roomNumber.text = roomNumber;
	}
	
	if (self.roomDescription != nil) {
		NSString *description = [poi.description copy];
		self.roomDescription.text = description;
	}
	
	if (self.buildingName != nil) {
		NSString *buildingName = [poi.floorPlan.building.name copy];
		self.buildingName.text = buildingName;
	}
}

- (void)clearCellWithPrompt:(NSString *)prompt;
{
	if (self.roomNumber != nil) {
		self.roomNumber.text = nil;
	}
	
	if (self.roomDescription != nil) {
		self.roomDescription.text = prompt;
	}
	
	if (self.buildingName != nil) {
		self.buildingName.text = nil;
	}
}


@end
