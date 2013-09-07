//
//  AppDelegate.h
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ViewController;
@class RailTimeModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) RailTimeModel *myShareModel;
@end
