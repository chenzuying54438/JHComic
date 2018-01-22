//
//  ComicCollectionViewCell.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/14.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end
