//
//  News.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/11/25.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface News : NSObject

-(instancetype)initWithTitle:(NSString*)title withContent:(NSString *)content;
-(instancetype)initWithDictionary:(NSDictionary *)dict;

@property (copy, nonatomic) NSString *ctime;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *des;
@property (copy, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *url;

@end
