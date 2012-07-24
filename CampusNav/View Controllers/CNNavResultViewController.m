//
//  CNNavResultViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavResultViewController.h"
#import "CNPathNode.h"

#import <QuartzCore/QuartzCore.h>

@interface CNNavResultViewController ()

@end

@implementation CNNavResultViewController

#pragma mark - Getter & Setter
@synthesize floorPlanView = _floorPlanView;
@synthesize floorPlanScrollView = _floorPlanScrollView;
@synthesize resultPoints = _resultPoints;

#pragma mark - View controller events

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NavResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	CNPathNode *node = [self.resultPoints objectAtIndex:indexPath.row];
	
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
