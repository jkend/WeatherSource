//
//  CurrentConditionsVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CurrentConditionsVC.h"
#import "Model/Wunderground.h"
#import "HourlyView/HourlyView.h"

@interface CurrentConditionsVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;

@property (nonatomic, strong) NSDictionary *currentConditions;
@property (nonatomic, strong) NSDictionary *hourlyForecast;
@end

@implementation CurrentConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCurrentConditions:) name:@"NewCurrentConditions" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHourlyForecast:) name:@"NewHourlyForecast" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


-(void) receiveCurrentConditions:(NSNotification *)notification {

    self.currentConditions = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
         [self updateCC];
    });
}

-(void) receiveHourlyForecast:(NSNotification *)notification {
    NSLog(@"Got hourly");
    self.hourlyForecast = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateHourly];
    });
}


-(void) updateCC {
    self.cityLabel.text = [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_CITY_PATH];
    
    // Careful, some of this data is NSNumber (as opposed to NSString)
    self.currentTempLabel.text =  [NSString stringWithFormat:@"%@°", [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_TEMP_PATH]];
    self.windsLabel.text = [NSString stringWithFormat:@"Winds: %@ %@",
                            [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_WIND_SPEED_PATH],
                            [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_WIND_DIRECTION_PATH]];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_HUMIDITY_PATH]];
    self.descriptionLabel.text = [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_DESCR_PATH];
    
}

-(void) updateHourly {
    [self.hourlyScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *hours = self.hourlyForecast[@"hourly_forecast"];
    int scrollViewWidth = 0;
    CGRect svFrame = self.hourlyScrollView.frame;
    NSLog(@"scrollview frame: %f %f %f %f", svFrame.origin.x, svFrame.origin.y, svFrame.size.width, svFrame.size.height);
    for (int hr = 0; hr < 12; hr++) {
        
        NSDictionary *hour = hours[hr];
        CGRect frameRect = CGRectMake(0, 0, 0.7 * self.hourlyScrollView.frame.size.height, self.hourlyScrollView.frame.size.height);
        HourlyView *hv = [[HourlyView alloc] initWithFrame:frameRect];
        
        hv.hour = [hour valueForKeyPath:@"FCTTIME.hour"];
        hv.temp = [hour valueForKeyPath:@"temp.english"];
        hv.imageURL = [hour valueForKey:@"icon_url"];
        frameRect = hv.frame;
        frameRect.origin.x = scrollViewWidth;
        hv.frame = frameRect;
        NSLog(@"frame: %f %f %f %f", hv.frame.origin.x, hv.frame.origin.y, hv.frame.size.width, hv.frame.size.height);
        [self.hourlyScrollView addSubview:hv];
        scrollViewWidth += hv.frame.size.width;
    }
    [self.hourlyScrollView setContentSize:CGSizeMake(scrollViewWidth, self.hourlyScrollView.frame.size.height)];
    [self.hourlyScrollView layoutIfNeeded];
}

@end
