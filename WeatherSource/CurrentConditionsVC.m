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
@property (nonatomic, strong) NSMutableArray<HourForecast *> *hourlyForecast;
@property (nonatomic, strong) NSMutableArray<DayForecast *> *extendedForecast;
@property (nonatomic, strong) DayForecast *todayForecast;
@end

static const int NumberOfHourlyForecasts = 12;

@implementation CurrentConditionsVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Was trying to use this constraint to get the scrollview to scroll, but no luck so far!
    self.tvHeightConstraint = [NSLayoutConstraint constraintWithItem:self.extendedForecastTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    self.hourlyForecast = [[NSMutableArray alloc] init];
    self.extendedForecast = [[NSMutableArray alloc] init];
    [self.extendedForecastTableView registerNib:[UINib nibWithNibName:@"OutlookTableViewCell" bundle:nil] forCellReuseIdentifier:@"Outlook Cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewWeatherData:) name:@"NewWeatherData" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

// MARK: Notification handler
-(void) receiveNewWeatherData:(NSNotification *)notification {
    
    self.currentConditions = [[CurrentConditions alloc] initWithData:notification.userInfo];
    [self setupHourly:notification.userInfo];
    [self setupExtended:notification.userInfo];
    //NSLog(@"%@", [notification.userInfo valueForKeyPath:@"forecast.simpleforecast.forecastday"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
    });
}

// MARK: Update Model
-(void)setupHourly:(NSDictionary *)dict {
    [self.hourlyForecast removeAllObjects];
    NSArray *rawHours = dict[WUNDERGROUND_HOURLY_KEY];
    for (int hr = 0; hr < NumberOfHourlyForecasts; hr++) {
        HourForecast *hourForecast = [[HourForecast alloc] initWithData:rawHours[hr]];
        [self.hourlyForecast addObject:hourForecast];
    }
}

-(void)setupExtended:(NSDictionary *)dict {
    [self.extendedForecast removeAllObjects];
    NSArray *rawDays = [dict valueForKeyPath:WUNDERGROUND_EXTENDED_PATH];
    self.todayForecast = [[DayForecast alloc] initWithData:[rawDays firstObject]];
    for (int dInd = 1; dInd < [rawDays count]; dInd++) {
        NSDictionary *dict = rawDays[dInd];
        DayForecast *dayForecast = [[DayForecast alloc] initWithData:dict];
        [self.extendedForecast addObject:dayForecast];
    }
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
    //CGRect svFrame = self.hourlyScrollView.frame;
    //NSLog(@"scrollview frame: %f %f %f %f", svFrame.origin.x, svFrame.origin.y, svFrame.size.width, svFrame.size.height);
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
    if (!cell) {
        
    }
    cell.dayLabel.text = self.extendedForecast[indexPath.row].day;
    cell.highLabel.text = self.extendedForecast[indexPath.row].highTemp;
    cell.lowLabel.text = self.extendedForecast[indexPath.row].lowTemp;
    cell.iconURL = self.extendedForecast[indexPath.row].iconURLString;
    return cell;
}

@end
