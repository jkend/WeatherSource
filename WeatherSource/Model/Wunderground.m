//
//  Wunderground.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wunderground.h"
#import "WunderKey.h"

@interface Wunderground()

@end

@implementation Wunderground

// MARK: Weather queries, all params at once
+(void) getWeather:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_CC_HOURLY_EXTENDED, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}


+(void) getWeatherFromLatitude:(double)latitude andLongitude:(double)longitude withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%f,%f.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_CC_HOURLY_EXTENDED,latitude, longitude ];
    [self getJSonResponse:queryString completion:completion];
}

+(void) getWeatherFromZMW:(NSString *)zmwQueryString withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_CC_HOURLY_EXTENDED, zmwQueryString ];
    [self getJSonResponse:queryString completion:completion];
}

// MARK: methods specifying single feature
+(void) getCurrentConditions:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    //NSLog(@"In getCurrentConditions");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_CURRENT_CONDITION, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}


+(void) getHourlyForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    //    NSLog(@"In getHourly");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_HOURLY_FORECAST, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}

+(void) getExtendedForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
     //NSLog(@"In getExtended");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_EXTENDED_FORECAST, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}

+(void)getAutoCompletions:(NSString *)partialCityString withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    //URL encode the partial string
    NSString *encString = [partialCityString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *queryString = [NSString stringWithFormat:@"%@%@", WUNDERGROUND_AUTOCOMPLETE_URL, encString ];
    
    [self getJSonResponse:queryString completion:completion];
    
}

// MARK: Send the query, handle response
+(void)getJSonResponse:(NSString *)queryString
         completion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSLog(@"getJSonResponse, %@", queryString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        if (!error) {
                                                            
                                                            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                            if (error) {
                                                                NSLog(@"error parsing");
                                                                completion(nil, error);
                                                            } else {
                                                                // phew!
                                                                completion(dictionary, nil);
                                                            }
                                                        } else {
                                                            completion(nil, error);
                                                        }
                                                    }];
    [postDataTask resume];
}
@end







