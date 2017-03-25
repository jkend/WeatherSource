//
//  OutlookTableViewCell.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/21/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "OutlookTableViewCell.h"
#import "../Utils/UIImage+Helpers.h"

@interface OutlookTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end
@implementation OutlookTableViewCell

-(void)setIconURL:(NSString *)iconURL {
    _iconURL = iconURL;
    [UIImage loadFromURL:[NSURL URLWithString:_iconURL] callback:^(UIImage *image) {
        self.iconImageView.image = image;
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
