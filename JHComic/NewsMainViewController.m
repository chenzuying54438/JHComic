//
//  NewsMainViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/7.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "NewsMainViewController.h"
#import "Utility.h"
#import "NewsViewController.h"

@interface NewsMainViewController  () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;

@property (strong, nonatomic) NSArray *categoryList;
@end

@implementation NewsMainViewController

-(id)categoryList {
    if(!_categoryList) {
         NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsUrls.plist" ofType:nil];
        _categoryList = [NSArray arrayWithContentsOfFile:path];
    }
    return _categoryList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLabels];
    [self addChildren];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    
    self.bigScrollView.delegate = self;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    
    NewsViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = [self.bigScrollView bounds];
    [self.bigScrollView addSubview:vc.view];
    
    [self setLabelSelected:0 withFlag:YES];
}

- (void)addLabels {
    NSUInteger count = self.categoryList.count;
    CGFloat labelH = CGRectGetHeight(self.smallScrollView.frame);
    CGFloat labelW = 70.0;
    CGFloat labelY = 0.0;
    for(NSUInteger i = 0;i < count;i++) {
        CGFloat labelX = i*labelW;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = self.categoryList[i][@"title"];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [label addGestureRecognizer:tap];
        [self.smallScrollView addSubview:label];
        
    }
    self.smallScrollView.contentSize = CGSizeMake(count*labelW, labelH);
}

- (void)setLabelSelected:(NSUInteger)labIndex withFlag:(BOOL)flag {
    UILabel *label = [self.smallScrollView.subviews objectAtIndex:labIndex];
    if(flag) {
        label.textColor = [UIColor redColor];
    }else {
        label.textColor = [UIColor blackColor];
    }
}

- (void)addChildren {
    CGFloat viewH = CGRectGetHeight(self.bigScrollView.frame);
    CGFloat viewW = CGRectGetWidth(self.bigScrollView.frame);
    for(NSUInteger i = 0;i < self.categoryList.count;i++) {
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.newsCategory = self.categoryList[i][@"path"];
        [self addChildViewController:vc];
    }
    
}

#pragma mark - ******************** scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
    UILabel *titleLabel = (UILabel *)self.smallScrollView.subviews[index];
    
    CGFloat offsetx = titleLabel.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    NewsViewController *newsVc = self.childViewControllers[index];
    [self setLabelSelected:index withFlag:YES];
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
//            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
//            temlabel.scale = 0.0;
            [self setLabelSelected:idx withFlag:NO];
        }
    }];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    // 取出绝对值 避免最左边往右拉时形变超过1
//    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
//    NSUInteger leftIndex = (int)value;
//    NSUInteger rightIndex = leftIndex + 1;
//    CGFloat scaleRight = value - leftIndex;
//    CGFloat scaleLeft = 1 - scaleRight;
//    UILabel *labelLeft = self.smallScrollView.subviews[leftIndex];
//    //labelLeft.scale = scaleLeft;
//    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
//    if (rightIndex < self.smallScrollView.subviews.count) {
////        SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
////        labelRight.scale = scaleRight;
//    }
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)labelClick:(UITapGestureRecognizer*)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    self.title = self.categoryList[label.tag][@"title"];
    [self setLabelSelected:label.tag withFlag:YES];
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != label.tag) {
            //            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
            //            temlabel.scale = 0.0;
            [self setLabelSelected:idx withFlag:NO];
        }
    }];
    CGFloat offsetX = label.tag * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentOffset = CGPointMake(offsetX, 0);
    NewsViewController *newsVc = self.childViewControllers[label.tag];
    if (newsVc.view.superview) return;
    newsVc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
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
