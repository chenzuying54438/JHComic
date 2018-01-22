//
//  NewsTableViewCell.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/9.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setNews:(News *)news {
    _news = news;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.news.picUrl] placeholderImage:[UIImage imageNamed:nil]];
    self.titleLabel.text = self.news.title;
    self.subtitleLabel.text = self.news.description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
