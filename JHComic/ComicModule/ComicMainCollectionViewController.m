//
//  ComicMainCollectionViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/10.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "ComicMainCollectionViewController.h"
#import "CategoryCollectionViewCell.h"
#import "ComicCollectionViewCell.h"
#import "ComicNetClient.h"
#import "Comic.h"
#import "Utility.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ComicCollectionViewController.h"
#import "ComicDetalViewController.h"

@interface ComicMainCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *cateList;
@property (strong, nonatomic) NSMutableArray *searchComicList;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ComicMainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)cateList {
    if(!_cateList) {
        _cateList = [NSMutableArray array];
        _searchComicList = [NSMutableArray array];
    }
    return _cateList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat winWidth = CGRectGetWidth(self.view.bounds);
    
    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    //包着搜索框外层的颜色
    //self.searchController.searchBar.barTintColor = [UIColor yellowColor];
    //提醒字眼
    self.searchController.searchBar.placeholder= @"漫画名|作者";
    //提前在搜索框内加入搜索词
    //self.searchController.searchBar.text = @"我是周杰伦";
    //设置UISearchController的显示属性，以下3个属性默认为YES
    
    //搜索时，背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    
    //点击搜索的时候,是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, winWidth, 30);
    self.navigationItem.titleView = self.searchController.searchBar;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];

    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchComicList removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"name"] = self.searchController.searchBar.text;
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/book" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        //       NSString *result = [[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding];
        //       NSLog(@"%@",result);
        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        NSArray *bookList = result[@"bookList"];
        for (NSDictionary *book in bookList) {
            Comic *comic = [[Comic alloc] initWithDictionary:book];
            [self.searchComicList addObject:comic];
        }

        [weakSelf.collectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    [self.cateList removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/category" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *catesFromResponse = [JSON valueForKeyPath:@"result"];
        for (NSString *cate in catesFromResponse) {
            [self.cateList addObject:cate];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
  
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        });

        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
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
    if(self.searchController.active)
        return self.searchComicList.count;
    else
        return self.cateList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchController.active)
    {
        static NSString *comicReuseIdenfier = @"ComicCell";
        UINib *nib = [UINib nibWithNibName:@"ComicCollectionViewCell" bundle: [NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:comicReuseIdenfier];
        ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:comicReuseIdenfier forIndexPath:indexPath];
        // Configure the cell
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        
        Comic *comic = self.searchComicList[indexPath.row];
        [cell.cover sd_setImageWithURL:[NSURL URLWithString:comic.coverImg] placeholderImage:[UIImage imageNamed:nil]];
        cell.title.text = comic.name;
        cell.author.text = comic.area;
        return cell;
    }
    else
    {
        static NSString *categoryReuseIdenfier = @"CategoryCell";
        UINib *nib = [UINib nibWithNibName:@"CategoryCollectionViewCell" bundle: [NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:categoryReuseIdenfier];
        CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryReuseIdenfier forIndexPath:indexPath];
    // Configure the cell
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    
        NSString *str = [NSString stringWithFormat:@"%ld", indexPath.row];
        cell.imgIcon.image = [UIImage imageNamed:str];
        cell.cateLabel.text = self.cateList[indexPath.row];
        return cell;
    }
}

#pragma mark  <UICollectionViewDelegateFlowLayout>

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchController.active)
    {
        ComicDetalViewController *detailVc = [[ComicDetalViewController alloc] initWithNibName:@"ComicDetalViewController" bundle:nil];
        detailVc.comic = self.searchComicList[indexPath.row];
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    else
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(105, 145);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        ComicCollectionViewController *comicVc = [[ComicCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
        comicVc.comicType = self.cateList[indexPath.row];
        comicVc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:comicVc animated:YES];
    }

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
