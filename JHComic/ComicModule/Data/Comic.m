//
//  Comic.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/14.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "Comic.h"

@implementation Comic

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        //finish attri to do
        _area = [dict[@"area"] copy];
        _coverImg = [dict[@"coverImg"] copy];
        _type = [dict[@"type"] copy];
        _lastUpdate = [dict[@"lastUpdate"] copy];
        _des = [dict[@"des"] copy];
        _name = [dict[@"name"] copy];
        _chapterList = nil;
    }
    return self;
}
@end
