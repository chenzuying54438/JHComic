//
//  ComicDetalViewController.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/15.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comic.h"
#import "MBProgressHUD.h"
#import "MWPhotoBrowser.h"

@interface ComicDetalViewController : UIViewController <MBProgressHUDDelegate, MWPhotoBrowserDelegate>

@property (strong, nonatomic) Comic *comic;

@end
