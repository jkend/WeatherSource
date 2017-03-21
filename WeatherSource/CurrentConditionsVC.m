//
//  CurrentConditionsVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CurrentConditionsVC.h"
#import "HourlyView/HourlyView.h"

#import "Model/Wunderground.h"
#import "Model/CurrentConditions.h"
#import "Model/HourForecast.h"

@interface CurrentConditionsVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;

@property (nonatomic, strong) CurrentConditions *currentConditions;
@property (nonatomic, strong) NSMutableArray<HourForecast *> *hourlyForecast;

@end

static const int NumberOfHourlyForecasts = 12;

@implementation CurrentConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hourlyForecast = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewWeatherData:) name:@"NewWeatherData" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(void) receiveNewWeatherData:(NSNotification *)notification {
    
    self.currentConditions = [[CurrentConditions alloc] initWithData:notification.userInfo];
    [self setupHourly:notification.userInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
    });
}

-(void)setupHourly:(NSDictionary *)dict {
    [self.hourlyForecast removeAllObjects];
    NSArray *rawHours = dict[WUNDERGROUND_HOURLY_KEY];
    for (int hr = 0; hr < NumberOfHourlyForecasts; hr++) {
        HourForecast *hourForecast = [[HourForecast alloc] initWithData:rawHours[hr]];
        [self.hourlyForecast addObject:hourForecast];
    }
}


-(void)refreshUI {
    [self updateCC];
    [self updateHourly];
}

-(void) updateCC {
    self.cityLabel.text = self.currentConditions.city;
    self.currentTempLabel.text =  [NSString stringWithFormat:@"%@°", self.currentConditions.temperature ];
    self.windsLabel.text = [NSString stringWithFormat:@"Winds: %@ %@",
                            self.currentConditions.windDirection, self.currentConditions.windSpeed];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", self.currentConditions.humidity];
    self.descriptionLabel.text = self.currentConditions.weatherDescription;
    
}

-(void) updateHourly {
    [self.hourlyScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int scrollViewWidth = 0;
    CGRect svFrame = self.hourlyScrollView.frame;
    NSLog(@"scrollview frame: %f %f %f %f", svFrame.origin.x, svFrame.origin.y, svFrame.size.width, svFrame.size.height);
    for (HourForecast *hour in self.hourlyForecast) {
        CGRect frameRect = CGRectMake(0, 0, 0.7 * self.hourlyScrollView.frame.size.height, self.hourlyScrollView.frame.size.height);
        
        HourlyView *hv = [[HourlyView alloc] initWithFrame:frameRect];
        hv.hour = hour.hour;
        hv.temp = hour.temperature ;
        hv.imageURL = hour.iconURLString;
        
        frameRect = hv.frame;
        frameRect.origin.x = scrollViewWidth;
        hv.frame = frameRect;
        //NSLog(@"frame: %f %f %f %f", hv.frame.origin.x, hv.frame.origin.y, hv.frame.size.width, hv.frame.size.height);
        [self.hourlyScrollView addSubview:hv];
        scrollViewWidth += hv.frame.size.width;
    }
    [self.hourlyScrollView setContentSize:CGSizeMake(scrollViewWidth, self.hourlyScrollView.frame.size.height)];
    [self.hourlyScrollView layoutIfNeeded];
}

@end
