//
//  ViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "ViewController.h"
#import "DirectionViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableDictionary *lines;
@property (strong, nonatomic) NSMutableArray *stations;
@end

@implementation ViewController

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
	self.stations = [[NSMutableArray alloc] init];
	self.lines = [[NSMutableDictionary alloc] init];
	
	PFQuery *queryStation = [PFQuery queryWithClassName:@"Station"];
	[queryStation orderByAscending:@"order"];
	[queryStation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			[self.stations addObjectsFromArray:objects];
			
			for (PFObject *station in self.stations) {
				NSString *lineName = [station valueForKey:@"line"];
				
				NSMutableDictionary *line = [self.lines valueForKey:lineName];
				
				if (line) {
					//line exist
					NSMutableArray *stations = [line valueForKey:@"stations"];
					[stations addObject:station];
					[line setValue:stations forKey:@"stations"];
				} else {
					//line doesn't exist
					line = [[NSMutableDictionary alloc] init];
					[line setValue:lineName forKey:@"name"];
					NSMutableArray *stations = [NSMutableArray arrayWithObject:station];
					[line setValue:stations forKey:@"stations"];
					[self.lines setValue:line forKey:lineName];
				}
			}
		} else {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (IBAction)setStation:(UIButton *)button {
	StationPickerViewController *stationPickerController = [[StationPickerViewController alloc] init];
	stationPickerController.delegate = self;
	stationPickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	stationPickerController.lines = self.lines;
	stationPickerController.stations = self.stations;
	[self presentModalViewController:stationPickerController animated:YES];
}

- (IBAction)setTimeToReach {
	TimePickerViewController *timePickerController = [[TimePickerViewController alloc] init];
	timePickerController.delegate = self;
	timePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:timePickerController animated:YES];
}

- (IBAction)loadTime {
	DirectionViewController *directionController = [[DirectionViewController alloc] init];
	directionController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:directionController animated:YES];
}

#pragma mark - Delegates

- (void)stationPickerController:(StationPickerViewController *)controller didPickIndexPath:(NSIndexPath *)indexPath
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

- (void)timePickerController:(TimePickerViewController *)controller didPickTime:(NSDate *)date
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

@end
