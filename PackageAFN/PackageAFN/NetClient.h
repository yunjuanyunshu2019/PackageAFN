//
//  NetClient.h
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger,RequestMethod){
    Get = 0,
    Post,
    Put, // 暂未用到
    Delete, // 暂未用到
};

@interface NetClient : AFHTTPSessionManager
/**
 获取请求对象
 
 @return 请求对象
 */
+ (instancetype)sharedClient;

/**
 请求网络数据，手动弹出错误提示
 
 @param aPath 相对路径
 @param params 参数
 @param needCache 是否需要缓存
 @param method 请求方式 RequestMethod
 @param autoShowError 是否自动弹出错误提示
 @param block 返回数据 第一个参数是请求数据 第二个参数是错误信息
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                      needCache:(BOOL)needCache
                 withMethodType:(RequestMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

@end


