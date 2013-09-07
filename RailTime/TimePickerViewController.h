//
//  TimePickerViewController.h
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimePickerViewController;

@protocol TimePickerViewControllerDelegate
- (void)timePickerController:(TimePickerViewController *)controller didPickTime:(NSDate *)date;
@end

@interface TimePickerViewController : UIViewController
@property (weak, nonatomic) id <TimePickerViewControllerDelegate> delegate;
@end
