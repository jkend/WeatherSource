//
//  CurrentConditionsVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CurrentConditionsVC.h"
#import "HourlyView/HourlyView.h"
#import "OutlookTableViewCell/OutlookTableViewCell.h"

#import "Model/Wunderground.h"
#import "Model/CurrentConditions.h"
#import "Model/HourForecast.h"
#import "Model/DayForecast.h"
#import "Model/WeatherDataManager.h"

@interface CurrentConditionsVC ()
// MARK: Outlets
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaysHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaysLowLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;
@property (weak, nonatomic) IBOutlet UITableView *extendedForecastTableView;

@property (weak, nonatomic)  NSLayoutConstraint *tvHeightConstraint;

// MARK: Model
@property (nonatomic, strong) CurrentConditions *currentConditions;
@property (nonatomic, strong) NSArray<HourForecast *> *hourlyForecast;
@property (nonatomic, strong) NSArray<DayForecast *> *extendedForecast;
@property (nonatomic, strong) DayForecast *todayForecast;
@end

@implementation CurrentConditionsVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Was trying to use this constraint to get the scrollview to scroll, but no luck so far!
    self.tvHeightConstraint = [NSLayoutConstraint constraintWithItem:self.extendedForecastTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    //self.hourlyForecast = [[NSMutableArray alloc] init];
    //self.extendedForecast = [[NSMutableArray alloc] init];
    [self.extendedForecastTableView registerNib:[UINib nibWithNibName:@"OutlookTableViewCell" bundle:nil] forCellReuseIdentifier:@"Outlook Cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewWeatherData:) name:@"WeatherDataReady" object:[WeatherDataManager sharedManager].activeCityKey];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWeatherData:) name:@"LocationChanged" object:[WeatherDataManager sharedManager].activeCityKey];
}

// MARK: Notification handlers
-(void) receiveNewWeatherData:(NSNotification *)notification {
    NSLog(@"VC can look for weather data, object = %@", notification.object);
    if (![notification.object isEqualToString:[WeatherDataManager sharedManager].activeCityKey]) {
        NSLog(@"not the city we're looking for!");
        return;
    }
    [self refreshWeatherData];
}

-(void) changeWeatherData:(NSNotification *)notification {
    NSLog(@"changeWeatherData");
    [self refreshWeatherData];
}

// MARK: Update our data
-(void)refreshWeatherData {
    NSLog(@"refreshing weather data");
    self.currentConditions = [[WeatherDataManager sharedManager] getActiveCurrentConditions];
    self.hourlyForecast = [[WeatherDataManager sharedManager] getActiveHourly];
    self.extendedForecast = [[WeatherDataManager sharedManager] getActiveForecast];
    self.todayForecast = [[WeatherDataManager sharedManager] getActiveTodayForecast];
    //NSLog(@"%@", [notification.userInfo valueForKeyPath:@"forecast.simpleforecast.forecastday"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
    });
}


// MARK: Update UI
-(void)refreshUI {
    [self updateCC];
    [self updateHourly];
    [self.extendedForecastTableView reloadData];
}

-(void) updateCC {
    self.cityLabel.text = self.currentConditions.city;
    self.currentTempLabel.text =  [NSString stringWithFormat:@"%@°", self.currentConditions.temperature ];
    self.windsLabel.text = [NSString stringWithFormat:@"Winds: %@ %@",
                            self.currentConditions.windDirection, self.currentConditions.windSpeed];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", self.currentConditions.humidity];
    self.descriptionLabel.text = self.currentConditions.weatherDescription;
    
    self.todayLabel.text = [NSString stringWithFormat:@"Today  %@", self.todayForecast.day];
    self.todaysHighLabel.text = self.todayForecast.highTemp;
    self.todaysLowLabel.text = self.todayForecast.lowTemp;
}

-(void) updateHourly {
    [self.hourlyScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int scrollViewWidth = 0;

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

// MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.extendedForecast count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutlookTableViewCell *cell = [self.extendedForecastTableView dequeueReusableCellWithIdentifier:@"Outlook Cell"];
    cell.dayLabel.text = self.extendedForecast[indexPath.row].day;
    cell.highLabel.text = self.extendedForecast[indexPath.row].highTemp;
    cell.lowLabel.text = self.extendedForecast[indexPath.row].lowTemp;
    cell.iconURL = self.extendedForecast[indexPath.row].iconURLString;
    return cell;
}

@end
