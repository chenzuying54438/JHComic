//
//  ComicSetViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/16.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "ComicSetViewController.h"


@interface ComicSetViewController  ()

@end

@implementation ComicSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在加载数据";
    
    [hud hide:YES afterDelay:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
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
