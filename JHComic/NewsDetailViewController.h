//
//  NewsDetailViewController.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/8.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

-(instancetype)initWithUrl:(NSString *)url;

@property (copy, nonatomic) NSString *newsUrl;

@end
