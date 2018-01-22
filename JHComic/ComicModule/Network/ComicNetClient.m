//
//  ComicNetClient.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/10.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "ComicNetClient.h"
#import "Utility.h"

@implementation ComicNetClient

+(instancetype)sharedClient
{
    static ComicNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:COMICURL];
        _sharedClient = [[ComicNetClient alloc] initWithBaseURL:url];
       _sharedClient.responseSerializer.acceptableContentTypes =  [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

@end
