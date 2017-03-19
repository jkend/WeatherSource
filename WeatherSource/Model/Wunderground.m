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

+(void) getCurrentConditions:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSLog(@"In getCurrentConditions");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_CURRENT_CONDITION, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}

+(void) getHourlyForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
        NSLog(@"In getHourly");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_HOURLY_FORECAST, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}

+(void) getExtendedForecast:(NSString *)ofCity inState:(NSString *)state withCompletion:(void (^)(NSDictionary *, NSError *))completion {
     NSLog(@"In getExten ded");
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@/%@/%@.json", WUNDERGROUND_BASE_URL, WundergroundAPIKey, WUNDERGROUND_QUERY_EXTENDED_FORECAST, state, ofCity ];
    
    [self getJSonResponse:queryString completion:completion];
}

+(void)getJSonResponse:(NSString *)queryString
         completion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSLog(@"getJSonResponse, %@", queryString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        if (!error) {
                                                            NSLog(@"Got response, no error");
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







