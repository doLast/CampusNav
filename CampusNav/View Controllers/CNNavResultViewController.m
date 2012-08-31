//
//  CNNavResultViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavResultViewController.h"
#import "YRDropdownView.h"

#import "CNUICustomize.h"
#import "CNPathCalculator.h"
#import "CNPathNode.h"
#import "GGSystem.h"

#import <QuartzCore/QuartzCore.h>

@interface CNNavResultViewController ()

@property (nonatomic, strong) NSArray *pathNodes;
@property (nonatomic, strong) NSDictionary *floorPlanToImage;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CNNavResultViewController

#pragma mark - Getter & Setter
@synthesize pathNodes = _pathNodes;
@synthesize floorPlanToImage = _floorPlanToImage;
@synthesize operationQueue = _operationQueue;

@synthesize floorPlanView = _floorPlanView;
@synthesize floorPlanScrollView = _floorPlanScrollView;
@synthesize tableView = _tableView;
@synthesize tableViewBacklay = _tableViewBacklay;
@synthesize pathCalculator = _pathCalculator;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[CNUICustomize dropShadowFromCeilingForView:self.tableViewBacklay];
}

- (void)viewWillAppear:(BOOL)animated
{
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator startAnimating];
	[YRDropdownView showDropdownInView:self.view title:@"Calculating Path" detail:nil accessoryView:activityIndicator animated:animated hideAfter:0.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
	if (self.pathCalculator == nil) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	NSOperation *initialization = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(initializeData) object:nil];
	
	self.operationQueue = [[NSOperationQueue alloc] init];
	[self.operationQueue addOperation:initialization];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeData
{
	NSArray *pathNodes = [self.pathCalculator executeCalculation];
	
	// Prepare floorPlans Image
	NSMutableDictionary *floorPlanToImage = [NSMutableDictionary dictionary];
	for (CNPathNode *node in pathNodes) {
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
	for (CNPathNode *node in pathNodes) {
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
	
	self.floorPlanToImage = floorPlanToImage;
	self.pathNodes = pathNodes;
	
	[self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:NO];
}

- (void)refreshData
{
	if ([self.pathNodes count] > 0) {
//		[YRDropdownView hideDropdownInView:self.view animated:YES];
		
		[self.tableView reloadData];
		// Select the first row in the tableView to start navigation
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView selectRowAtIndexPath:indexPath
									animated:YES
							  scrollPosition:UITableViewScrollPositionTop];
		[self.tableView.delegate tableView:self.tableView
				   didSelectRowAtIndexPath:indexPath];
	}
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
	
	// Config the cell according to the node
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
	// Find the corresponding node
	CNPathNode *node = [self.pathNodes objectAtIndex:indexPath.row];
	GGFloorPlan *floorPlan = node.current.floorPlan;
	
	// If is going up or down, use the next node's floor plan
	if (node.type == kCNPathNodeTypeUpStairs || node.type == kCNPathNodeTypeDownStairs) {
		floorPlan = node.next.floorPlan;
	}
	
	// Find the floor's image
	UIImage *image = [self.floorPlanToImage objectForKey:floorPlan.fId];
	NSAssert(image != nil, @"Failed to load floor plan image");
	
	// Replace the image if is not the same one
	if (self.floorPlanView.image != image) {
		self.floorPlanView.image = image;
		[self.floorPlanView sizeToFit];
		self.floorPlanScrollView.contentSize = image.size;
		NSString * floorName = [NSString stringWithFormat:@"%@ %@", floorPlan.building.abbreviation, floorPlan.description];
		// Show notification
		[YRDropdownView showDropdownInView:self.view
									 title:[NSString stringWithFormat:@"You are now on %@ floor", floorName]
									detail:nil
									 image:nil
								  animated:YES
								 hideAfter:1];
	}
	
	// Scroll the image to the node's coordinate
	CGFloat	width = self.floorPlanScrollView.bounds.size.width;
	CGFloat height = self.floorPlanScrollView.bounds.size.height;
	CGFloat x = node.current.coordinate.x - width / 2;
	CGFloat y = node.current.coordinate.y - height / 2;
	[self.floorPlanScrollView scrollRectToVisible:CGRectMake(x, y, width, height) animated:YES];
}

@end
