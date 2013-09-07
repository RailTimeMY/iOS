//
//  RailTimeModel.m
//  RailTime
//
//  Created by Rick on 9/7/13.
//  Copyright (c) 2013 RailTime. All rights reserved.
//

#import "RailTimeModel.h"

@implementation RailTimeModel


+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

@end
