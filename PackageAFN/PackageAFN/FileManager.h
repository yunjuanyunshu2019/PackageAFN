//
//  FileManager.h
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject
//加载请求
+ (id)loadResponseWithPath:(NSString *)requestPath;
//缓存请求
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;
@end

NS_ASSUME_NONNULL_END
