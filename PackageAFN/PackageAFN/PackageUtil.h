//
//  PackageUtil.h
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackageUtil : NSObject
+ (NSInteger)showToast:(NSString *)toast;
/**
 md5
 
 @param string --
 @return --
 */
+ (NSString *)md5:(NSString *)string;


/**
 获取错误的字符串
 
 @param error 错误信息
 @return 错误字符串
 */
+ (NSString *)tipFromError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
