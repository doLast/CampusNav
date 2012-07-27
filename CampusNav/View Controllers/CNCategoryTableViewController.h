//
//  CNCategoryTableViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPOIPool;
@class CNGeoGraphSelectionViewController;
@class CNPOITableViewController;

@interface CNCategoryTableViewController : UITableViewController <UISearchDisplayDelegate>
@property (nonatomic, strong) IBOutlet CNGeoGraphSelectionViewController *selectionViewController;
@property (nonatomic, strong) IBOutlet CNPOITableViewController *searchResultTableDelegate;

@end
