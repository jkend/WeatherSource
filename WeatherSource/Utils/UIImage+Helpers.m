//
//  UIImage+Helpers.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/20/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSError * error = nil;
        NSData * imageData = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if (error)
            callback(nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

@end
