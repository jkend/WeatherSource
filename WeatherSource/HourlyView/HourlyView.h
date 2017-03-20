//
//  HourlyView.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/20/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSString *temp;
@end
