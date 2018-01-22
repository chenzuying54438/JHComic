//
//  NewsDetailViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/8.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h>

@interface NewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsDetailViewController

-(instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if(self) {
        _newsUrl = [url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.newsUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
