//
//  StationPickerViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "StationPickerViewController.h"

@interface StationPickerViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation StationPickerViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setTableView:nil];
	[super viewDidUnload];
}

- (IBAction)goBack {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lines.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.lines.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *lineName;
	if (section < self.lines.allKeys.count)
		 lineName = [self.lines.allKeys objectAtIndex:section];
	
	NSMutableArray *stations = [[self.lines valueForKey:lineName] valueForKey:@"stations"];
	
	return stations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
	NSString *lineName;
	if (indexPath.section < self.lines.allKeys.count)
		lineName = [self.lines.allKeys objectAtIndex:indexPath.section];
	
	NSMutableArray *stations = [[self.lines valueForKey:lineName] valueForKey:@"stations"];
	
	if (indexPath.row >= stations.count)
		return nil;
	
	cell.textLabel.text = [[stations objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate stationPickerController:self didPickIndexPath:indexPath];
}

@end
