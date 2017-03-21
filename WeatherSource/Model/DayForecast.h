//
//  DayForecast.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//


@interface DayForecast : NSObject

@property (nonatomic, strong, readonly) NSString *day;
@property (nonatomic, strong, readonly) NSString *highTemp;
@property (nonatomic, strong, readonly) NSString *lowTemp;
@property (nonatomic, strong, readonly) NSString *iconURLString;

- (id)initWithData:(NSDictionary *)dict;
@end
