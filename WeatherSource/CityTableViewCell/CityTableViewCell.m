//
//  CityTableViewCell.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/24/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CityTableViewCell.h"
#import "../Model/CurrentConditions.h"
#import "../Utils/UIImage+Helpers.h"

@interface CityTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;

@end

@implementation CityTableViewCell


-(void)setCityConditions:(CurrentConditions *)cityConditions {
    _cityConditions = cityConditions;
    self.cityLabel.text = _cityConditions.city;
    self.tempLabel.text =  [NSString stringWithFormat:@"%@°", cityConditions.temperature ];
    [UIImage loadFromURL:[NSURL URLWithString:cityConditions.iconURLString] callback:^(UIImage *image) {
        self.conditionsImageView.image = image;
    }];
}

@end
