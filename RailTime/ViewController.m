//
//  ViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>

#import "DirectionViewController.h"

#import "RailTimeModel.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableDictionary *lines;
@property (strong, nonatomic) NSMutableArray *stations;

@property (strong, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *nearestButton;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

@property (nonatomic) RailTimeModel *myShareModel;
@property (nonatomic) GMSMarker *marker;
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
			
			self.nearestButton.enabled = self.destinationButton.enabled = YES;
		} else {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
	
	GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapContainer.bounds camera:nil];
	mapView.myLocationEnabled = YES;
	self.mapView = mapView;
	[self.mapContainer addSubview:self.mapView];
	
	[self.nearestButton.layer setCornerRadius:15];
	[self.timeButton.layer setCornerRadius:15];
	[self.destinationButton.layer setCornerRadius:15];
	[self.goButton.layer setCornerRadius:15];
}

- (void)viewDidAppear:(BOOL)animated
{
	self.myShareModel = [RailTimeModel sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationChanges) name:@"updateLocationChanges" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

-(void)updateLocationChanges {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myShareModel.myLocation.latitude longitude:self.myShareModel.myLocation.longitude zoom:16];
	[self.mapView animateToCameraPosition:camera];
}

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
	NSMutableDictionary * dict  = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:3.13229] forKey:@"selectedStationLatitude"];
    [dict setObject:[NSNumber numberWithFloat:101.68774] forKey:@"selectedStationLongitude"];
    [dict setObject:[NSNumber numberWithFloat:2.75474] forKey:@"destinationStationLatitude"];
    [dict setObject:[NSNumber numberWithFloat:101.70582] forKey:@"destinationStationLongitude"];
    [dict setObject:@"5PM" forKey:@"timeToReachAtDestination"];
	[PFCloud callFunctionInBackground:@"hello" withParameters:dict block:^(NSString *result, NSError *error) {
		if (!error) {
			// result is @"Hello world!"
			
		}
	}];
	
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

- (void)viewDidUnload {
	[self setMapView:nil];
	[self setNearestButton:nil];
	[self setDestinationButton:nil];
	[self setGoButton:nil];
	[self setTimeButton:nil];
	[self setMapContainer:nil];
	[super viewDidUnload];
}
@end
