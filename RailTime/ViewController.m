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

#import "AppDelegate.h"
#import "RailTimeModel.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableDictionary *lines;
@property (strong, nonatomic) NSMutableArray *stations;

@property (strong, nonatomic) PFObject *stationNearest;
@property (strong, nonatomic) NSDate *arrivalTime;
@property (strong, nonatomic) PFObject *stationDestination;

@property (strong, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) UIButton *selectedButton;

@property (strong, nonatomic) IBOutlet UIButton *nearestButton;
@property (strong, nonatomic) UILabel *nearestStationLabel;

@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@property (strong, nonatomic) UILabel *destinationLabel;

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
	GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapContainer.bounds camera:nil];
	mapView.myLocationEnabled = YES;
	self.mapView = mapView;
	[self.mapContainer addSubview:self.mapView];
	
	UILabel *nearestTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.nearestButton.bounds.size.width/2) - 45, 2, 90, 15)];
	nearestTitle.text = @"Nearest Station";
	nearestTitle.font = [UIFont systemFontOfSize:12];
	nearestTitle.backgroundColor = [UIColor clearColor];
	nearestTitle.textAlignment = UITextAlignmentCenter;
	[self.nearestButton addSubview:nearestTitle];
	
	UILabel *nearestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.nearestButton.bounds.size.width, 29)];
	nearestLabel.font = [UIFont systemFontOfSize:22];
	nearestLabel.minimumFontSize = 16;
	nearestLabel.adjustsFontSizeToFitWidth = YES;
	nearestLabel.backgroundColor = [UIColor clearColor];
	nearestLabel.textAlignment = UITextAlignmentCenter;
	self.nearestStationLabel = nearestLabel;
	[self.nearestButton addSubview:nearestLabel];
	
	UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.timeButton.bounds.size.width/2) - 45, 2, 90, 15)];
	timeTitle.text = @"Time to Reach";
	timeTitle.font = [UIFont systemFontOfSize:12];
	timeTitle.backgroundColor = [UIColor clearColor];
	timeTitle.textAlignment = UITextAlignmentCenter;
	[self.timeButton addSubview:timeTitle];
	
	self.arrivalTime = [NSDate dateWithTimeIntervalSinceNow:3600];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.timeButton.bounds.size.width, 29)];
	timeLabel.text = [formatter stringFromDate:self.arrivalTime];
	timeLabel.font = [UIFont systemFontOfSize:22];
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.textAlignment = UITextAlignmentCenter;
	self.timeLabel = timeLabel;
	[self.timeButton addSubview:timeLabel];
	
	UILabel *destinationTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.destinationButton.bounds.size.width/2) - 55, 2, 110, 15)];
	destinationTitle.text = @"Destination Station";
	destinationTitle.font = [UIFont systemFontOfSize:12];
	destinationTitle.backgroundColor = [UIColor clearColor];
	destinationTitle.textAlignment = UITextAlignmentCenter;
	[self.destinationButton addSubview:destinationTitle];
	
	UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.destinationButton.bounds.size.width, 29)];
	destinationLabel.font = [UIFont systemFontOfSize:22];
	destinationLabel.minimumFontSize = 16;
	destinationLabel.adjustsFontSizeToFitWidth = YES;
	destinationLabel.backgroundColor = [UIColor clearColor];
	destinationLabel.textAlignment = UITextAlignmentCenter;
	self.destinationLabel = destinationLabel;
	[self.destinationButton addSubview:destinationLabel];
	
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
					NSMutableArray *stations = [line valueForKey:@"stations"];
					[stations addObject:station];
					[line setValue:stations forKey:@"stations"];
				} else {
					line = [[NSMutableDictionary alloc] init];
					[line setValue:lineName forKey:@"name"];
					NSMutableArray *stations = [NSMutableArray arrayWithObject:station];
					[line setValue:stations forKey:@"stations"];
					[self.lines setValue:line forKey:lineName];
				}
				
				PFGeoPoint *geopoint = [station valueForKey:@"coordinate"];
				CLLocationCoordinate2D position = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude);
				
				GMSMarker *marker = [GMSMarker markerWithPosition:position];
				marker.title = [NSString stringWithFormat:@"%@ (%@ line)", [station valueForKey:@"name"], [station valueForKey:@"line"]];
				
				CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.myShareModel.myLocation.latitude longitude:self.myShareModel.myLocation.longitude];
				CLLocation *station = [[CLLocation alloc] initWithLatitude:position.latitude longitude:position.longitude];
				CLLocationDistance distance = [userLocation distanceFromLocation:station];
				marker.snippet = [NSString stringWithFormat:@"%.2fkm", distance/1000.0];
				
//				UIColor *markerColour = [UIColor blackColor];
//				switch ([[station valueForKey:@"markerColour"] intValue]) {
//					case 0: //Kelana Jaya
//						markerColour = [UIColor blackColor];
//						break;
//					case 1: //Sri Petaling
//						markerColour = [UIColor greenColor];
//						break;
//					case 2: //Monorail
//						markerColour = [UIColor redColor];
//						break;
//					case 3: //KTM Seremban
//						markerColour = [UIColor blueColor];
//						break;
//					case 4: //KTM Klang
//						markerColour = [UIColor yellowColor];
//						break;
//					case 5: //KLIA Transit
//						markerColour = [UIColor purpleColor];
//						break;
//					default:
//						markerColour = [UIColor blackColor];
//						break;
//				}
//				marker.icon = [GMSMarker markerImageWithColor:markerColour];
				
				marker.map = self.mapView;
			}
			
			self.nearestButton.enabled = self.destinationButton.enabled = YES;
		} else {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
	
	[self.nearestButton.layer setCornerRadius:10];
	[self.timeButton.layer setCornerRadius:10];
	[self.destinationButton.layer setCornerRadius:10];
	[self.goButton.layer setCornerRadius:10];
	
	[self.goButton.layer setBorderColor:[UIColor darkGrayColor].CGColor];
	[self.goButton.layer setBorderWidth:3];
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myShareModel.myLocation.latitude longitude:self.myShareModel.myLocation.longitude zoom:15];
	[self.mapView animateToCameraPosition:camera];
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.locationManager stopUpdatingLocation];
}

- (IBAction)setStation:(UIButton *)button {
	self.selectedButton = button;
	
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
	directionController.stationNearest = self.stationNearest;
	directionController.arrivalTime = self.arrivalTime;
	directionController.stationDestination = self.stationDestination;
	[self presentModalViewController:directionController animated:YES];
}

#pragma mark - Delegates

- (void)stationPickerController:(StationPickerViewController *)controller didPickIndexPath:(NSIndexPath *)indexPath
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
	
	NSString *lineName;
	if (indexPath.section < self.lines.allKeys.count)
		lineName = [self.lines.allKeys objectAtIndex:indexPath.section];
	NSMutableArray *stations = [[self.lines valueForKey:lineName] valueForKey:@"stations"];
	PFObject *station = [stations objectAtIndex:indexPath.row];
	NSString *stationString = [NSString stringWithFormat:@"%@ (%@)", [station valueForKey:@"name"], [station valueForKey:@"line"]];
	
	if (self.selectedButton == self.nearestButton) {
		self.nearestStationLabel.text = stationString;
		self.stationNearest = station;
	} else if (self.selectedButton == self.destinationButton) {
		self.destinationLabel.text = stationString;
		self.stationDestination = station;
	}
}

- (void)timePickerController:(TimePickerViewController *)controller didPickTime:(NSDate *)date
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	self.timeLabel.text = [formatter stringFromDate:date];
	
	self.arrivalTime = date;
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
