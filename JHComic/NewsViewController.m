//
//  NewsViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/11/25.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "News.h"
#import "MJRefresh.h"
#import "AFNetClient.h"
#import "Utility.h"
#import "NewsTableViewCell.h"

NSString *sharedContent = @"The UIKit framework provides the required infrastructure for your iOS or tvOS apps. It provides the window and view architecture for implementing your interface, the event handling infrastructure for delivering Multitouch and other types of input to your app, and the main run loop needed to manage interactions among the user, the system, and your app. Other features offered by the framework include animation support, document support, drawing and printing support, information about the current device, text management and display, search support, accessibility support, app extension support, and resource management.";

@interface NewsViewController ()
{
    NSArray *wordArray;
}

@property (strong, nonatomic) NSMutableArray *newsList;

@end

@implementation NewsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsList = [NSMutableArray array];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NewsCell"];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//@"social/?key=b32e0076aac631e330ee52f159708e26&num=10"
-(void)loadNewData
{
    [self.newsList removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"num"] = @10;
    params[@"key"] = APIKEY;
    params[@"page"] = @0;
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[AFNetClient sharedClient] GET:self.newsCategory parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *newsFromResponse = [JSON valueForKeyPath:@"newslist"];
        for (NSDictionary *attributes in newsFromResponse) {
            News *post = [[News alloc] initWithDictionary:attributes];
            [self.newsList addObject:post];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}

-(void)loadMoreData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"num"] = @10;
    params[@"key"] = APIKEY;
    params[@"page"] = @(self.newsList.count);
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[AFNetClient sharedClient] GET:self.newsCategory parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        //       NSString *result = [[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding];
        //       NSLog(@"%@",result);
        NSArray *newsFromResponse = [JSON valueForKeyPath:@"newslist"];
        for (NSDictionary *attributes in newsFromResponse) {
            News *post = [[News alloc] initWithDictionary:attributes];
            [self.newsList addObject:post];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}

- (UIImage *)buildSwatch:(int)aBrightness
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0f];
    [[[UIColor blackColor] colorWithAlphaComponent:(float)aBrightness / 10.0f] set];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)addContainer
{
    UITableView *tableView = (UITableView *)self.view;
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    tableView.frame = CGRectMake(0, 50, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    self.view = containerView;
    [containerView addSubview:tableView];
    
    //add the view as a subview of the container view, it will be fixed on the top
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), 50)];
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:topView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}



//- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
//    UIViewController *previewingViewController = [UIViewController new];
//    previewingViewController.view.backgroundColor = [UIColor redColor];
//    return previewingViewController;
//}
//
//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
//
//}
//
//- (void)dealloc {
//    if (_didRegisterForPreviewing) {
//        [self unregisterForPreviewingWithContext:self.previewingContext];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.newsList objectAtIndex:indexPath.row];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] initWithUrl:news.url];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if(!cell) {
        //cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
        cell=[[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil] lastObject];
    }
    News *news = [self.newsList objectAtIndex:indexPath.row];
    
    [cell setNews:news];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
