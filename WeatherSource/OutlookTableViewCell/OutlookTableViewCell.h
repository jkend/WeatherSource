//
//  OutlookTableViewCell.h
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutlookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;

@property (nonatomic, strong) NSString *iconURL;
@end
