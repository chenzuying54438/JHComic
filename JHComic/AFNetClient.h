//
//  AFNetClient.h
//  Demo_Navigation
//
//  Created by chenzuying on 2017/12/6.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
