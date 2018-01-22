//
//  AFNetClient.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/6.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "AFNetClient.h"
#import "Utility.h"

@implementation AFNetClient

//static NSString * const AFAppDotNetAPIBaseURLString = @"http://api.tianapi.com/";

+(instancetype)sharedClient
{
    static AFNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNetClient alloc] initWithBaseURL:[NSURL URLWithString:NEWSURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}
@end
