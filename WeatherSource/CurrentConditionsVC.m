//
//  CurrentConditionsVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/19/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CurrentConditionsVC.h"
#import "Model/Wunderground.h"

@interface CurrentConditionsVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (nonatomic, strong) NSDictionary *currentConditions;
@end

@implementation CurrentConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCurrentConditions:) name:@"NewCurrentConditions" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


-(void) receiveCurrentConditions:(NSNotification *)notification {

    self.currentConditions = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
         [self updateUI];
    });
}


-(void) updateUI {
    self.cityLabel.text = [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_CITY_PATH];
    
    // Careful, some of this data is NSNumber (as opposed to NSString)
    NSNumber *temp = [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_TEMP_PATH];
    self.currentTempLabel.text =  temp.stringValue; //[self.currentConditions valueForKeyPath:WUNDERGROUND_CC_TEMP_PATH];
    self.windsLabel.text = [NSString stringWithFormat:@"Winds: %@ %@",
                            [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_WIND_SPEED_PATH],
                            [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_WIND_DIRECTION_PATH]];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_HUMIDITY_PATH]];
    self.descriptionLabel.text = [self.currentConditions valueForKeyPath:WUNDERGROUND_CC_DESCR_PATH];
    
}

@end
