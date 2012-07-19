//
//  CNGeoGraphSelectionViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCNNewPOIPoolNotification;
extern NSString * const kCNNewPOIPoolNotificationTitle;
extern NSString * const kCNNewPOIPoolNotificationData;

@interface CNGeoGraphSelectionViewController : NSObject 
<CLLocationManagerDelegate, UIActionSheetDelegate, 
UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *locateButton;

- (IBAction)updateSelection:(id)sender;
- (IBAction)startLocating:(id)sender;
- (IBAction)stopLocating:(id)sender;
- (IBAction)chooseFloorPlan:(id)sender;
- (IBAction)dismissActionSheet:(id)sender;

@end
