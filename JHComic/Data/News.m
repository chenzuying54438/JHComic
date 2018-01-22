//
//  News.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/11/25.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "News.h"
#import "Utility.h"

@implementation News

- (UIImage *)imageForString:(NSString *)aString
{

    return nil;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self) {
        _ctime = [dict[@"ctime"] copy];
        _title = [dict[@"title"] copy];
        _des = [dict[@"description"] copy];
        _picUrl = [dict[@"picUrl"] copy];
        _url = [dict[@"url"] copy];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content
{
    self = [super init];
    if(self) {

    }
    return self;
}
@end
