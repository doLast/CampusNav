//
//  CNNavResultViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNPathCalculator;

@interface CNNavResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *floorPlanView;
@property (nonatomic, weak) IBOutlet UIScrollView *floorPlanScrollView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *tableViewBacklay;

@property (nonatomic, strong) CNPathCalculator *pathCalculator;

@end
