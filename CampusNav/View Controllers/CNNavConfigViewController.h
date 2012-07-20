//
//  CNNavConfigViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCNNavConfigNotification;
extern NSString * const kCNNavConfigNotificationType;
extern NSString * const kCNNavConfigNotificationData;

extern NSString * const kCNNavConfigTypeSource;
extern NSString * const kCNNavConfigTypeDestination;

@class GGPOI;
@class CNPOICell;

@interface CNNavConfigViewController : UITableViewController

@property (nonatomic, strong) GGPOI *sourcePOI;
@property (nonatomic, strong) GGPOI *destinationPOI;

@property (nonatomic, weak) IBOutlet CNPOICell *navSourceCell;
@property (nonatomic, weak) IBOutlet CNPOICell *navDestinationCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *startNavCell;

@end
