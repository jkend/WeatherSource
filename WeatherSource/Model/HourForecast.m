//
//  HourForecast.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HourForecast.h"
#import "Wunderground.h"

@interface HourForecast()
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *iconURLString;

@end

@implementation HourForecast

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.hour =  [dict valueForKeyPath:WUNDERGROUND_HOURLY_HOUR_PATH];
        self.temperature = [dict valueForKeyPath:WUNDERGROUND_HOURLY_TEMP_PATH];
        self.iconURLString = [dict valueForKey:WUNDERGROUND_HOURLY_ICON_PATH];
    }
    return self;
    
}
@end
