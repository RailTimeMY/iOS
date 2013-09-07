//
//  TimePickerViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation TimePickerViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.datePicker setDate:self.arrivalTime animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

- (IBAction)setTime {
	[self.delegate timePickerController:self didPickTime:self.datePicker.date];
}

- (void)viewDidUnload {
	[self setDatePicker:nil];
	[super viewDidUnload];
}
@end
