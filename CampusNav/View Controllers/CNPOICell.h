//
//  CNPOICell.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPOI;

@interface CNPOICell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *roomNumber;
@property (nonatomic, weak) IBOutlet UILabel *roomDescription;
@property (nonatomic, weak) IBOutlet UILabel *buildingName;

- (void)fillCellWithPOI:(GGPOI *)poi;
- (void)clearCellWithPrompt:(NSString *)prompt;

@end
