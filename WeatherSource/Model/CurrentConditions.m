//
//  CurrentConditions.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentConditions.h"
#import "Wunderground.h"

@interface CurrentConditions()
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic, strong) NSString *windDirection;
@property (nonatomic, strong) NSString *windSpeed;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *iconURLString;
@end

@implementation CurrentConditions

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.city = [dict valueForKeyPath:WUNDERGROUND_CC_CITY_PATH];
        // Careful, some of this data is NSNumber (as opposed to NSString)
        // Here, let's round the temp to the nearest whole number (the decimal
        // part of a degree isn't that interesting).
        NSString *temp = [dict valueForKeyPath:WUNDERGROUND_CC_TEMP_PATH];
        self.temperature =  [NSString stringWithFormat:@"%@", @(round([temp doubleValue]))];
        
        self.windSpeed = [dict valueForKeyPath:WUNDERGROUND_CC_WIND_SPEED_PATH];
        self.windDirection = [dict valueForKeyPath:WUNDERGROUND_CC_WIND_DIRECTION_PATH];
        self.humidity = [dict valueForKeyPath:WUNDERGROUND_CC_HUMIDITY_PATH];
        self.weatherDescription = [dict valueForKeyPath:WUNDERGROUND_CC_DESCR_PATH];
        self.iconURLString = [dict valueForKeyPath:WUNDERGROUND_CC_ICONURL_PATH];
    }
    return self;
    
}

- (NSString *)description {
    NSString *des = [NSString stringWithFormat:@"city: %@, temperature: %@, weather: %@, icon: %@", self.city, self.temperature, self.weatherDescription, self.iconURLString];
    return des;
}
@end
