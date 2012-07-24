//
//  CNNavResultViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNNavResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIImageView *floorPlanView;
@property (nonatomic, strong) IBOutlet UIScrollView *floorPlanScrollView;

@property (nonatomic, strong) NSArray *resultPoints;

@end
