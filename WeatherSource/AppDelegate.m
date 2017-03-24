//
//  AppDelegate.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Model/Wunderground.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSTimer *locationUpdateTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self shutdownLocationUpdates];
    [self saveLastCityViewed];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"ApplicationWillEnterForeground");

    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"ApplicationDidBecomeActive");

    // get conditions from our current location, if we're allowed
    BOOL canUseLocation = [self setupLocationManager];
    if (canUseLocation) {
        NSLog(@"location manager ready");
        [self getQuickLocationUpdate];
        self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval: 6000.0
                                                      target: self
                                                    selector:@selector(getQuickLocationUpdate)
                                                    userInfo: nil repeats:YES];
    }
    
    // load any saved cities
    NSArray *savedCities = [self loadFavoriteCities];
    if ([savedCities count] > 0) {
        for (NSString *savedCity in savedCities) {
            [self getWeatherInfoForCityFromKey:savedCity];
        }
    }
    // load the last city we were looking at, if any
    NSString *lastCityViewed = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCityViewed"];
    if (!lastCityViewed  && !canUseLocation) {
        lastCityViewed = @"Cambridge/MA";
    }
    [self getWeatherInfoForCityFromKey:lastCityViewed];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// MARK: saving and loading "favorite" cities
-(NSArray *)loadFavoriteCities {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favCities = [defaults objectForKey:@"favoriteCities"];
    if (!favCities) {
        // just for dev!
        return @[@"Seattle/WA", @"New_York/NY", @"Cambridge/MA"];
    }
    return favCities;
}

-(void)saveLastCityViewed {
    // NSString *cityViewed = [[WeatherManager sharedManager] activeCityKey];
    // [[NSUserDefaults standardDefaults] setObject:activeCityKey forKey:@"lastCityViewed"];
}

-(void)cityAndStateFromKey:(NSString *)key toCity:(NSString **)city andState:(NSString **)state {
    NSArray *items = [key componentsSeparatedByString:@"/"];
    *city = [items objectAtIndex:0];
    *state = [items objectAtIndex:1];
}

-(void)getWeatherInfoForCityFromKey:(NSString *)cityKey {
    NSString *city = nil;
    NSString *state = nil;
    [self cityAndStateFromKey:cityKey toCity:&city andState:&state];
    NSLog(@"getWeatherInfoForCityFromKey, city = %@ state = %@ key = %@", city, state, cityKey);
    if (city.length > 1 && state.length == 2) {
        [Wunderground getWeather:city
                         inState:state
                  withCompletion:^(NSDictionary *result, NSError *error) {
                      //[[WeatherManager sharedManager] addWeather:userInfo.result forKey:cityKey];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"NewWeatherData" object:cityKey userInfo:result];
                  }];
    }
}

// MARK: CLLocationManager setup
-(BOOL)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User hasn't ever been asked to give location authorization
    // Note: check for iOS 8 or later (this selector is new!)
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Location services denied");
        return NO;
    }
 
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.distanceFilter = 1000;
    return YES;
}

-(void)getQuickLocationUpdate {
    NSLog(@"getQuickLocationUpdate");
    [self.locationManager requestWhenInUseAuthorization];
    
    // Request a location update
    [self.locationManager requestLocation];
    // Note: requestLocation may timeout and produce an error if authorization has not yet been granted by the user
     //[self.locationManager stopUpdatingLocation];
}

-(void)shutdownLocationUpdates {
    [self.locationManager stopUpdatingLocation];
    [self.locationUpdateTimer invalidate];
}

// MARK: CLLocationManager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // most recent location is last
    CLLocation *loc = [locations lastObject];
    
    CLLocationDegrees latitude = loc.coordinate.latitude;
    CLLocationDegrees longitude = loc.coordinate.longitude;
    NSLog(@"%f, %f", latitude, longitude);
    [Wunderground getWeatherFromLatitude:latitude
                            andLongitude:longitude
                          withCompletion:^(NSDictionary *result, NSError *error) {
                              //[[WeatherManager sharedManager] addWeather:userInfo.result forKey:@"location"];
                              [[NSNotificationCenter defaultCenter]
                               postNotificationName:@"NewWeatherData" object:@"location" userInfo:result];
                          }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"failed!");
    [self shutdownLocationUpdates];
}
@end
