//
//  WeatherDataManager.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/23/17.
//  Copyright © 2017 Joy. All rights reserved.
//
@class CurrentConditions;
@class HourForecast;
@class DayForecast;

@interface WeatherDataManager : NSObject

@property (nonatomic, strong) NSString *activeCityKey;

+ (instancetype)sharedManager;

// CurrentConditionsVC will use these
- (CurrentConditions *)getActiveCurrentConditions;
- (NSArray<DayForecast *> *) getActiveForecast;
- (NSArray<HourForecast *> *) getActiveHourly;
- (DayForecast *) getActiveTodayForecast;


//- (CurrentConditions *)getCurrentConditionsForCity:(NSString *)city andState:(NSString *)state;
//- (NSArray *)getHourlyForCity:(NSString *)city andState:(NSString *)state;
//- (NSArray *)getForecastForCity:(NSString *)city andState:(NSString *)state;
@end
