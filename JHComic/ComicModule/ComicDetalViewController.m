//
//  ComicDetalViewController.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/15.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "ComicDetalViewController.h"
#import "UIImageView+WebCache.h"
#import "ComicNetClient.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "ComicSetViewController.h"

static NSString *toExpandString = @"阅读全部章节";
static NSString *expandedString = @"收起";

@interface ComicDetalViewController () {
    
}

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *headerDetailView;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastupdateLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;

@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@property (weak, nonatomic) IBOutlet UIView *chapterDetailView;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *chapterListView;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chapterHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;


@property (assign, nonatomic) Boolean expanded;

@property (strong, nonatomic) NSMutableArray *buttonArr;

@property (assign, atomic) int loadedCount;
@property (assign, atomic) int totalCount;

@property(strong, nonatomic)  MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *photosArray;
@end

@implementation ComicDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load");
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:self.comic.coverImg] placeholderImage:[UIImage imageNamed:nil]];
    self.titleLbl.text = self.comic.name;
    self.areaLbl.text = self.comic.area;
    self.lastupdateLbl.text = [NSString stringWithFormat:@"%d", self.comic.lastUpdate.intValue];
    self.expanded = false;
    self.chapterListView.clipsToBounds = YES;
    self.loadedCount = 0;
    [self updateChapterListView];
    [self loadChapters];
}

-(void)loadChapters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"comicName"] = self.comic.name;
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/chapter" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {

        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        weakSelf.totalCount = [result[@"total"] intValue];
        int limit = [result[@"limit"] intValue];
        if(weakSelf.comic.chapterList == nil) {
            weakSelf.comic.chapterList = [NSMutableArray arrayWithCapacity:self.totalCount];
            for(int i = 0;i < self.totalCount;i++) {
                [weakSelf.comic.chapterList addObject:[NSNull null]];
            }
        }
        NSArray *chapterList = result[@"chapterList"];
        int index = 0;
        for (NSDictionary *chapter in chapterList) {
            weakSelf.comic.chapterList[index] = chapter;
            index++;
        }
        weakSelf.loadedCount += chapterList.count;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateChapterListView];
            [self.view layoutIfNeeded];
        });
        
        int toLoadCount = weakSelf.totalCount - chapterList.count;
        int skip = chapterList.count;
        while(toLoadCount >= 0) {
            [weakSelf loadChapters:skip];
            skip += limit;
            toLoadCount -= limit;
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}

-(void)loadChapters:(int)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"comicName"] = self.comic.name;
    params[@"skip"] = [NSNumber numberWithInt:skip];
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/chapter" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        NSArray *chapterList = result[@"chapterList"];
        int index = skip;
        for (NSDictionary *chapter in chapterList) {
            weakSelf.comic.chapterList[index] = chapter;
            index++;
        }
        weakSelf.loadedCount += chapterList.count;
        if(weakSelf.loadedCount == weakSelf.totalCount) {
            NSLog(@"all chapters loaded");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateChapterListView];
                [self.view layoutIfNeeded];
            });
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"view will appear");
}

-(void)viewDidAppear:(BOOL)animated {
    //NSLog(@"view did appear");
    
}

-(void)updateViewConstraints {
    //NSLog(@"update constraints");
    [super updateViewConstraints];
}

-(void)viewWillLayoutSubviews {
   // NSLog(@"view will layout");
}
-(void)viewDidLayoutSubviews {
   // NSLog(@"did layout");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readClick:(UIButton *)sender {
}

- (IBAction)favoriteClick:(UIButton *)sender {
}

- (IBAction)expandClick:(UIButton *)sender {
    self.expanded = !(self.expanded);
    if(self.expanded)
        [self.expandBtn setTitle:expandedString forState:UIControlStateNormal];
    else
        [self.expandBtn setTitle:toExpandString forState:UIControlStateNormal];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        // Make all constraint changes here
        [self updateChapterListView];

        [self.view layoutIfNeeded];
    }];
}

-(void)updateChapterListView {
    int initCnt = self.loadedCount > 12 ? 12 : self.loadedCount;
    int totalCnt = self.totalCount;
    int cntPerRow = 4;
    CGFloat margin = 10.0;
    CGFloat gap = 5.0;
    
    
    int buttonCnt = 0;
    int rowCnt = 0;
    if(self.expanded) {
        buttonCnt = totalCnt;
    } else {
        buttonCnt = initCnt;
    }
    rowCnt = buttonCnt / cntPerRow;
    if(buttonCnt % cntPerRow)
        rowCnt += 1;
    
    CGFloat buttonWidth = (CGRectGetWidth(self.chapterListView.frame) - 2*margin - (cntPerRow-1)*gap)/cntPerRow;
    CGFloat buttonHeight = 50.0;
    
    if(self.buttonArr == nil && totalCnt != 0) {
        self.buttonArr = [NSMutableArray arrayWithCapacity:totalCnt];
        for(int i = 0;i < totalCnt;i++) {
            int row = i / cntPerRow;
            int col = i % cntPerRow;
            CGFloat bx = col * (buttonWidth + gap) + margin;
            CGFloat by = row * (buttonHeight + gap) + margin;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tag = i;
            [button addTarget:self action:@selector(btnChapterClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(bx, by, buttonWidth, buttonHeight);
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [self.chapterListView addSubview:button];
            
        }
    }
    

    
    CGFloat listViewHeight = margin + rowCnt*buttonHeight + (rowCnt)*gap;
    CGFloat chapterDetailViewHeight = listViewHeight + CGRectGetHeight(self.headerLabel.frame) + CGRectGetHeight(self.expandBtn.frame);
    
    self.chapterHeightConstraint.constant = listViewHeight;
    self.containerHeightConstraint.constant = CGRectGetHeight(self.headerDetailView.frame) + chapterDetailViewHeight + 2*20.0;
}

- (void)btnChapterClick:(UIButton *)sender {
    NSDictionary *chapter = self.comic.chapterList[sender.tag];
    if([chapter isKindOfClass:[NSDictionary class]]){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.delegate = self;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"正在加载数据";
        [self loadChapterContent:[chapter[@"id"] intValue]];
    } else {
        NSLog(@"chapter error");
    }
}

-(void)loadChapterContent:(int)chapterId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = COMICKEY;
    params[@"comicName"] = self.comic.name;
    params[@"id"] = [NSNumber numberWithInt:chapterId];
    __unsafe_unretained __typeof(self) weakSelf = self;
    BOOL ret = [[ComicNetClient sharedClient] GET:@"comic/chapterContent" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *result = [JSON valueForKeyPath:@"result"];
            NSArray *imageList = result[@"imageList"];
            self.photosArray = [NSMutableArray array];
            for (NSDictionary *imageDict in imageList) {
                MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageDict[@"imageUrl"]]];
                [self.photosArray addObject:photo];
            }
            [self.hud hide:YES];
            MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            //set options
            [photoBrowser setCurrentPhotoIndex:0];
            [self.navigationController pushViewController:photoBrowser animated:YES];
        });
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"fail");
    }];
}
#pragma mark - MWPhotosBrowserDelegate
//必须实现的方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return  self.photosArray.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < self.photosArray.count) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}


#pragma mark - HUD delegate
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
