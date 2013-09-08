//
//  DirectionViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "DirectionViewController.h"
#import "RailTimeModel.h"

@interface DirectionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *directionCell;

@property (strong, nonatomic) NSMutableArray *onTimes;
@property (strong, nonatomic) PFObject *fastestRoute;
@property (assign, nonatomic) int fastestDuration;
@property (assign, nonatomic) CLLocationDistance nearestDistance;

@property (strong, nonatomic) RailTimeModel *myShareModel;
@end

@implementation DirectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.onTimes = [[NSMutableArray alloc] init];
	self.myShareModel = [RailTimeModel sharedModel];
	
	CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.myShareModel.myLocation.latitude longitude:self.myShareModel.myLocation.longitude];
	
	PFGeoPoint *geopoint = [self.stationNearest valueForKey:@"coordinate"];
	CLLocation *station = [[CLLocation alloc] initWithLatitude:geopoint.latitude longitude:geopoint.longitude];
	self.nearestDistance = [userLocation distanceFromLocation:station];
	
	for (PFObject *route in self.routes) {
		int totalDuration = [[route valueForKey:@"totalDuration"] intValue];
		
		NSDate *realArrivalTime = [NSDate dateWithTimeIntervalSinceNow:totalDuration];
		
		NSNumber *onTime = [NSNumber numberWithBool:([self.arrivalTime compare:realArrivalTime] == NSOrderedAscending) ? NO:YES];
		[self.onTimes addObject:onTime];
		
		if (onTime.boolValue)
			self.isOnTime = YES;
		
		if (self.fastestRoute) {
			if (totalDuration > self.fastestDuration) {
				self.fastestRoute = route;
				self.fastestDuration = totalDuration;
			}
		} else {
			self.fastestRoute = route;
			self.fastestDuration = totalDuration;
		}
	}
	
	self.titleLabel.text = (self.isOnTime) ? @"YOU WILL BE ON TIME!":@"YOU'RE ALREADY LATE...";
	if (!self.isOnTime)
		self.titleLabel.textColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (IBAction)goBack {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

- (void)viewDidUnload {
	[self setTableView:nil];
	[self setDirectionCell:nil];
	[self setTitleLabel:nil];
	[super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.routes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section >= self.onTimes.count)
		return @"";
	
	BOOL onTime = [[self.onTimes objectAtIndex:section] boolValue];
	
	return (onTime) ? @"On Time":@"Late";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *stations = [self.fastestRoute valueForKey:@"Stations"];
	
	return stations.count + ((self.nearestDistance > 100) ? 1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	}
	
	if (indexPath.section < self.onTimes.count) {
		BOOL onTime = [[self.onTimes objectAtIndex:indexPath.section] boolValue];
		cell.backgroundColor = (onTime) ? [UIColor greenColor]:[UIColor redColor];
	}
	
	PFObject *route = [self.routes objectAtIndex:indexPath.section];
	
	NSString *prefix = @"";
	
	if (self.nearestDistance > 100) {
		if (indexPath.row) {
			if (indexPath.row == 1)
				prefix = @"Get on at ";
			else if (indexPath.row == [[route valueForKey:@"Stations"] count])
				prefix = @"Arrive at ";
			NSString *stationName = [[route valueForKey:@"Stations"] objectAtIndex:indexPath.row - 1];
			cell.textLabel.text = [NSString stringWithFormat:@"%@%@", prefix, stationName];
		} else
			cell.textLabel.text = [NSString stringWithFormat:@"Walk %.1fkm to %@", self.nearestDistance/1000.0, [[route valueForKey:@"Stations"] objectAtIndex:0]];
	} else {
		if (!indexPath.row)
			prefix = @"Get on at ";
		else if (indexPath.row == [[route valueForKey:@"Stations"] count] - 1)
			prefix = @"Arrive at ";
		NSString *stationName = [[route valueForKey:@"Stations"] objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@%@", prefix, stationName];
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
