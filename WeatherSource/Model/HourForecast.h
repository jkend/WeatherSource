//
//  HourForecast.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//


@interface HourForecast : NSObject

@property (nonatomic, strong, readonly) NSString *temperature;
@property (nonatomic, strong, readonly) NSString *weatherDescription;
@property (nonatomic, strong, readonly) NSString *hour;
@property (nonatomic, strong, readonly) NSString *iconURLString;

- (id)initWithData:(NSDictionary *)dict;
@end
