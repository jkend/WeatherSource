//
//  HourlyView.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/20/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "HourlyView.h"

@interface HourlyView()
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation HourlyView

-(void)setTemp:(NSString *)temp {
    _temp = temp;
    self.tempLabel.text = temp;
}

-(void)setHour:(NSString *)hour {
    _hour = hour;
    int milHour = [hour intValue];
    NSString *ampm = (milHour < 12) ? @"AM" : @"PM";
    int normalHour = (milHour > 12) ? milHour - 12 : milHour;
    // kludge
    if (normalHour == 0) normalHour = 12;
    self.hourLabel.text = [NSString stringWithFormat:@"%d%@", normalHour, ampm];
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self loadFromXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadFromXib];
    }
    return self;
}

-(void)loadFromXib {
    [[NSBundle mainBundle] loadNibNamed:@"HourlyView" owner:self options:nil];
    [self addSubview:self.view];    
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
