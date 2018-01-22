//
//  NewsTableViewCell.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/9.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) News *news;

- (void)setNews:(News *)news;

@end
