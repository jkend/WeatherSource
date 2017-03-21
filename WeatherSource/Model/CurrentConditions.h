//
//  CurrentConditions.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//


@interface CurrentConditions : NSObject

@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *temperature;
@property (nonatomic, strong, readonly) NSString *weatherDescription;
@property (nonatomic, strong, readonly) NSString *windDirection;
@property (nonatomic, strong, readonly) NSString *windSpeed;
@property (nonatomic, strong, readonly) NSString *humidity;

- (id)initWithData:(NSDictionary *)dict;
@end
