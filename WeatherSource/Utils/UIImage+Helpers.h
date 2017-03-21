//
//  UIImage+Helpers.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/20/17.
//  Copyright © 2017 Joy. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end
