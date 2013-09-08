//
//  DirectionViewController.h
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionViewController : UIViewController
@property (assign, nonatomic) BOOL isOnTime;
@property (strong, nonatomic) PFObject *stationNearest;
@property (strong, nonatomic) NSDate *arrivalTime;
@property (strong, nonatomic) PFObject *stationDestination;
@property (strong, nonatomic) NSArray *routes;
@end
