//
//  ComicCollectionViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/14.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "ComicCollectionViewController.h"
#import "ComicCollectionViewCell.h"
#import "ComicNetClient.h"
#import "Utility.h"
#import "MJRefresh.h"
#import "Comic.h"
#import "UIImageView+WebCache.h"

#import "ComicDetalViewController.h"

@interface ComicCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *comicList;

@end

@implementation ComicCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)comicList {
    if(!_comicList) {
        _comicList = [NSMutableArray array];
    }
    return _comicList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];

    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)loadNewData
{
    [self.comicList removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"type"] = self.comicType;
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/book" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        //       NSString *result = [[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding];
        //       NSLog(@"%@",result);
        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        NSArray *bookList = result[@"bookList"];
        for (NSDictionary *book in bookList) {
            Comic *comic = [[Comic alloc] initWithDictionary:book];
            [self.comicList addObject:comic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        });

        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}

-(void)loadMoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"type"] = @"少年漫画";
    params[@"skip"] = @(self.comicList.count);
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/book" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        //       NSString *result = [[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding];
        //       NSLog(@"%@",result);
        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        NSArray *bookList = result[@"bookList"];
        for (NSDictionary *book in bookList) {
            Comic *comic = [[Comic alloc] initWithDictionary:book];
            [self.comicList addObject:comic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.comicList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *comicReuseIdenfier = @"ComicCell";
    UINib *nib = [UINib nibWithNibName:@"ComicCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:comicReuseIdenfier];
    ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:comicReuseIdenfier forIndexPath:indexPath];
    // Configure the cell
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    
    Comic *comic = self.comicList[indexPath.row];
    [cell.cover sd_setImageWithURL:[NSURL URLWithString:comic.coverImg] placeholderImage:[UIImage imageNamed:nil]];
    cell.title.text = comic.name;
    cell.author.text = comic.area;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ComicDetalViewController *detailVc = [[ComicDetalViewController alloc] initWithNibName:@"ComicDetalViewController" bundle:nil];
    detailVc.comic = self.comicList[indexPath.row];
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
