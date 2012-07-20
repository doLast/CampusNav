//
//  CNPOIDetailViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPOI;

@interface CNPOIDetailViewController : UITableViewController

@property (nonatomic, strong) GGPOI *poi;
@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;
@property (nonatomic, weak) IBOutlet UITableViewCell *favToggleCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *favNameCell;

- (IBAction)toggleFav:(UITableViewCell *)sender;
- (IBAction)setAsSource:(UITableViewCell *)sender;
- (IBAction)setAsDestination:(UITableViewCell *)sender;

@end
