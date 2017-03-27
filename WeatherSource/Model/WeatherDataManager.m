//
//  WeatherDataManager.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/23/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataManager.h"
#import "CurrentConditions.h"
#import "HourForecast.h"
#import "DayForecast.h"
#import "Wunderground.h"
//
static const int NumberOfHourlyForecasts = 12;

@interface WeatherDataManager()
@property (nonatomic, strong) NSMutableDictionary *allCities;
@end

@implementation WeatherDataManager

-(NSDictionary *)allCities {
    if (!_allCities) {
        _allCities = [[NSMutableDictionary alloc] init];
    }
    return _allCities;
}

-(void)setActiveCityKey:(NSString *)activeCityKey {
    NSLog(@"setting activeKey, newval = %@ oldval = %@", activeCityKey, _activeCityKey);
    NSString *oldKey = _activeCityKey;
    _activeCityKey = activeCityKey;
    if (oldKey) {
        // We've been initialized before, now we're changing
        // TODO Need to test if we're a "known" city already
        if (self.allCities[_activeCityKey]) {
            NSLog(@"updating activeKey. posting notification");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationChanged" object:_activeCityKey userInfo:nil];
        }
        else {
            NSLog(@"New place, getting data");

            [Wunderground getWeatherFromZMW:_activeCityKey
                                  withCompletion:^(NSDictionary *result, NSError *error) {
                                      [[NSNotificationCenter defaultCenter]
                                       postNotificationName:@"NewWeatherData" object:self.activeCityKey userInfo:result];
                                  }];        }
    }
    
}

// MARK: Returning the Singleton
+ (instancetype)sharedManager {
    static WeatherDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WeatherDataManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(receiveNewWeatherData:) name:@"NewWeatherData" object:nil];
    });
    
    return sharedInstance;
}

// MARK: Weather for the active city
// And "active" here means, the one being displayed in the main view controller
- (CurrentConditions *)getActiveCurrentConditions {
    NSLog(@"active current conditions, key=%@", self.activeCityKey);
    NSDictionary *cityDict = self.allCities[self.activeCityKey];
    CurrentConditions *cc = cityDict[@"current"];
    NSLog(@"%@", cc);
    return cc;
}
- (NSArray<DayForecast *> *) getActiveForecast {
    NSDictionary *cityDict = self.allCities[self.activeCityKey];
    return cityDict[@"forecast"];
}
- (NSArray<HourForecast *> *) getActiveHourly {
    NSDictionary *cityDict = self.allCities[self.activeCityKey];
    return cityDict[@"hourly"];
}

- (DayForecast *) getActiveTodayForecast {
    NSDictionary *cityDict = self.allCities[self.activeCityKey];
    return cityDict[@"today"];
}

- (NSUInteger)getSavedCitiesCount {
    return [self.allCities count];
}

- (NSArray *)getSavedCities {
    return [self.allCities allKeys];
}

- (CurrentConditions *)getCurrentConditionsForCity:(NSString *)key {
    NSDictionary *cityDict = self.allCities[key];
    return cityDict[@"current"];
}

// MARK: NSNotification handler
-(void) receiveNewWeatherData:(NSNotification *)notification {
    NSLog(@"WM receiving weather data, object = %@", notification.object);
    NSString *key = notification.object;
    NSDictionary *dict = notification.userInfo;
    CurrentConditions *cc = [[CurrentConditions alloc] initWithData:dict];
    
    NSArray *rawHours = dict[WUNDERGROUND_HOURLY_KEY];
    NSMutableArray<HourForecast *> *hf = [[NSMutableArray alloc] init];
    for (int hr = 0; hr < NumberOfHourlyForecasts; hr++) {
        HourForecast *hourForecast = [[HourForecast alloc] initWithData:rawHours[hr]];
        [hf addObject:hourForecast];
    }
    
    NSArray *rawDays = [dict valueForKeyPath:WUNDERGROUND_EXTENDED_PATH];
    DayForecast *todayForecast = [[DayForecast alloc] initWithData:[rawDays firstObject]];
    NSMutableArray<DayForecast *> *ef = [[NSMutableArray alloc] init];
    for (int dInd = 1; dInd < [rawDays count]; dInd++) {
        NSDictionary *dict = rawDays[dInd];
        DayForecast *dayForecast = [[DayForecast alloc] initWithData:dict];
        [ef addObject:dayForecast];
    }
    
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
    cityDict[@"current"] = cc;
    cityDict[@"hourly"] = hf;
    cityDict[@"forecast"] = ef;
    cityDict[@"today"] = todayForecast;
    
    self.allCities[key] = cityDict;
    NSLog(@"Put in new weather data!");
    NSLog(@"%@", cityDict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherDataReady" object:key userInfo:nil];

}
@end
