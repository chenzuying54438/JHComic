//
//  Comic.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/14.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comic : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@property (copy, nonatomic) NSString *finish;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *coverImg;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *lastUpdate;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *des;

@property (strong, nonatomic) NSMutableArray *chapterList;
@end
