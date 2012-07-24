//
//  CNNavResultViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavResultViewController.h"
#import "CNUICustomize.h"
#import "CNPathNode.h"
#import "GGSystem.h"

#import <QuartzCore/QuartzCore.h>

@interface CNNavResultViewController ()

@property (nonatomic, strong) NSDictionary *floorPlanToImage;

@end

@implementation CNNavResultViewController

#pragma mark - Getter & Setter
@synthesize floorPlanToImage = _floorPlanToImage;
@synthesize floorPlanView = _floorPlanView;
@synthesize floorPlanScrollView = _floorPlanScrollView;
@synthesize tableView = _tableView;
@synthesize tableViewBacklay = _tableViewBacklay;
@synthesize pathNodes = _pathNodes;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Prepare floorPlans Image
	NSMutableDictionary *floorPlanToImage = [NSMutableDictionary dictionary];
	for (CNPathNode *node in self.pathNodes) {
		GGFloorPlan *floorPlan = node.current.floorPlan;
		if ([floorPlanToImage objectForKey:floorPlan.fId] == nil) {
			NSString *imageFilename = [NSString stringWithFormat:@"%@_%02dFLR", 
									   floorPlan.building.abbreviation, 
									   floorPlan.floor];
			UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
			NSLog(@"Image loaded from %@ as %@", imageFilename, image);
			[floorPlanToImage setObject:image forKey:floorPlan.fId];
		}
	}
	
	// Drew path on images
	for (CNPathNode *node in self.pathNodes) {
		GGPoint *from = node.current;
		GGPoint *to = node.next;

		if (from != nil && to != nil) {
			NSLog(@"Drawing from: %d, %d to: %d, %d", from.coordinate.x, from.coordinate.y , to.coordinate.x, to.coordinate.y);
			GGFloorPlan *floorPlan = from.floorPlan;
			
			if (node.type == kCNPathNodeTypeUpStairs || node.type == kCNPathNodeTypeDownStairs) {
				floorPlan = to.floorPlan;
			}

			UIImage *image = [floorPlanToImage objectForKey:floorPlan.fId];
			
			UIGraphicsBeginImageContext(image.size);
			CGContextRef context = UIGraphicsGetCurrentContext();
			
			CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:50.0/255 green:130.0/255 blue:200.0/255 alpha:1].CGColor);
			
			CGContextTranslateCTM(context, 0, image.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
			CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
			
			CGContextSetLineWidth(context, 5.0f);
			CGContextMoveToPoint(context, from.coordinate.x, image.size.height - from.coordinate.y);
			CGContextAddLineToPoint(context, to.coordinate.x, image.size.height - to.coordinate.y);
			CGContextStrokePath(context);
			
			image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			[floorPlanToImage setObject:image forKey:floorPlan.fId];
		}
	}
	
	[CNUICustomize dropShadowFromCeilingForView:self.tableViewBacklay];
	
	self.floorPlanToImage = floorPlanToImage;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pathNodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NavResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	CNPathNode *node = [self.pathNodes objectAtIndex:indexPath.row];
	
	switch (node.type) {
		case kCNPathNodeTypeSource:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"source" ofType:@"png"]];
			break;
		case kCNPathNodeTypeDestination:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"destination" ofType:@"png"]];
			break;
		case kCNPathNodeTypeStraight:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"straight" ofType:@"png"]];
			break;
		case kCNPathNodeTypeLeft:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"left" ofType:@"png"]];
			break;
		case kCNPathNodeTypeRight:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"right" ofType:@"png"]];
			break;
		case kCNPathNodeTypeUpStairs:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"]];
			break;
		case kCNPathNodeTypeDownStairs:
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
			break;
		default:
			break;
	}
	cell.imageView.backgroundColor = [UIColor colorWithRed:50.0/255 green:130.0/255 blue:200.0/255 alpha:1];
	
	cell.textLabel.text = node.description;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance from previous: %dpx", node.distance];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CNPathNode *node = [self.pathNodes objectAtIndex:indexPath.row];
	GGFloorPlan *floorPlan = node.current.floorPlan;
	if (node.type == kCNPathNodeTypeUpStairs || node.type == kCNPathNodeTypeDownStairs) {
		floorPlan = node.next.floorPlan;
	}
	
	UIImage *image = [self.floorPlanToImage objectForKey:floorPlan.fId];
	assert(image != nil);
	if (self.floorPlanView.image != image) {
		self.floorPlanView.image = image;
		[self.floorPlanView sizeToFit];
		self.floorPlanScrollView.contentSize = image.size;
	}
	
	CGFloat	width = self.floorPlanScrollView.bounds.size.width;
	CGFloat height = self.floorPlanScrollView.bounds.size.height;
	CGFloat x = node.current.coordinate.x - width / 2;
	CGFloat y = node.current.coordinate.y - height / 2;
//	NSLog(@"Scrolling to x:%f y:%f w:%f h:%f", x, y, width, height);
	[self.floorPlanScrollView scrollRectToVisible:CGRectMake(x, y, width, height) animated:YES];
}

@end
