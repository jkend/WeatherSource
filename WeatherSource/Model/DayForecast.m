//
//  DayForecast.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayForecast.h"
#import "Wunderground.h"

@interface DayForecast()
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *highTemp;
@property (nonatomic, strong) NSString *lowTemp;
@property (nonatomic, strong) NSString *iconURLString;

@end

@implementation DayForecast

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.day =  [dict valueForKeyPath:WUNDERGROUND_EXTENDED_DAY_PATH];
        self.highTemp = [dict valueForKeyPath:WUNDERGROUND_EXTENDED_HIGHTEMP_PATH];
        self.lowTemp = [dict valueForKeyPath:WUNDERGROUND_EXTENDED_LOWTEMP_PATH];
        self.iconURLString = [dict valueForKey:WUNDERGROUND_EXTENDED_ICON_PATH];
    }
    return self;
    
}
@end
