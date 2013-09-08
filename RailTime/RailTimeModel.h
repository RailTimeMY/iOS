//
//  RailTimeModel.h
//  RailTime
//
//  Created by Rick on 9/7/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RailTimeModel : NSObject

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) NSString *selectedOriginalID;
@property (nonatomic) NSString *selectedDestinationID;
@property (nonatomic) NSMutableArray *routes;
@property (nonatomic) NSDate *selectedTime;

+ (id)sharedModel;

@end
