//
//  DirectionViewController.m
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *directionCell;

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
@end
