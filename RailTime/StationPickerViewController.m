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
    // Do any additional setup after loading the view from its nib.
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

@end
