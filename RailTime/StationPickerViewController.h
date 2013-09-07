//
//  StationPickerViewController.h
//  RailTime
//
//  Created by Sim Piin Kong on 7/9/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StationPickerViewController;

@protocol StationPickerViewControllerDelegate
- (void)stationPickerController:(StationPickerViewController *)controller didPickIndexPath:(NSIndexPath *)indexPath;
@end

@interface StationPickerViewController : UIViewController
@property (weak, nonatomic) id <StationPickerViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableDictionary *lines;
@property (strong, nonatomic) NSMutableArray *stations;
@end
