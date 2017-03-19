//
//  Wunderground.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#define WUNDERGROUND_BASE_URL                   @"http://api.wunderground.com/api/"
#define WUNDERGROUND_QUERY_CURRENT_CONDITION    @"/conditions/q"
#define WUNDERGROUND_QUERY_HOURLY_FORECAST      @"/hourly/q"
#define WUNDERGROUND_QUERY_EXTENDED_FORECAST    @"/forecast/q"

#define WUNDERGROUND_CC_CITY_PATH               @"current_observation.display_location.city"
#define WUNDERGROUND_CC_HUMIDITY_PATH           @"current_observation.relative_humidity"
#define WUNDERGROUND_CC_WIND_DIRECTION_PATH     @"current_observation.wind_dir"
#define WUNDERGROUND_CC_WIND_SPEED_PATH         @"current_observation.wind_mph"
#define WUNDERGROUND_CC_TEMP_PATH               @"current_observation.temp_f"
#define WUNDERGROUND_CC_DESCR_PATH              @"current_observation.weather"

@interface Wunderground : NSObject

+(void) getCurrentConditions:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion;
+(void) getHourlyForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion;
+(void) getExtendedForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion;


@end
