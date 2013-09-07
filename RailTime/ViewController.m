//
//  ViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "ViewController.h"
#import "DirectionViewController.h"
#import "StationPickerViewController.h"
#import "TimePickerViewController.h"

@interface ViewController ()

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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (IBAction)setStation:(UIButton *)button {
	StationPickerViewController *stationPickerController = [[StationPickerViewController alloc] init];
	stationPickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:stationPickerController animated:YES];
}

- (IBAction)setTimeToReach {
	TimePickerViewController *timePickerController = [[TimePickerViewController alloc] init];
	timePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:timePickerController animated:YES];
}

- (IBAction)loadTime {
	DirectionViewController *directionController = [[DirectionViewController alloc] init];
	directionController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:directionController animated:YES];
}

@end
