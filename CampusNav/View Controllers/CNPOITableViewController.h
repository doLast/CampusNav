//
//  CNPOITableViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPOIPool;

@interface CNPOITableViewController : UITableViewController
@property (nonatomic, strong) GGPOIPool *poiPool;
@property (nonatomic, strong) IBOutlet CNPOITableViewController *searchResultTableDelegate;
@property (nonatomic, weak) IBOutlet UIViewController *mainViewController;

@end
