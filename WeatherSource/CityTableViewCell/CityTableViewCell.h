//
//  CityTableViewCell.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/24/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrentConditions;

@interface CityTableViewCell : UITableViewCell
@property (nonatomic, strong) CurrentConditions *cityConditions;
@property (nonatomic, strong) NSString *myKey;
@end
