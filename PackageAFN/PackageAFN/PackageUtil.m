//
//  PackageUtil.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "PackageUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <Accelerate/Accelerate.h>
#import <MBProgressHUD.h>

@implementation PackageUtil


+ (NSInteger)showToast:(NSString *)toast {
    
//stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    if ([toast isKindOfClass:[NSString class]] && [toast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        CGFloat time = 1;
        NSInteger multiple = ceil(toast.length / 10.0f);
        time *= multiple;
        if (time > 4) {
            time = 4;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = toast;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:time];
        
        return time;
    }
    return 0;
}

+ (NSString*) tipFromError:(NSError*)error {
    if (error && error.userInfo) {
        
        NSString *errStr = nil;
        
        if ([error.userInfo objectForKey:@"errmsg"]) {
            
            errStr = [error.userInfo objectForKey:@"errmsg"];
        } else if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
            
            errStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];//NSLocalizedDescription
        } else if ([error.userInfo objectForKey:@"message"]) {
            
            id msg = [error.userInfo objectForKey:@"message"];
            
            if ([msg isKindOfClass:[NSDictionary class]]) {
                errStr = msg[@"error"];
            } else if ([msg isKindOfClass:[NSString class]]) {
                errStr = msg;
            }
            
        } else if ([error.userInfo objectForKey:@"messsage"]) {
            
            errStr = [error.userInfo objectForKey:@"messsage"];
            
        }  else if ([error.userInfo objectForKey:@"msg"]) {
            
            errStr = [error.userInfo objectForKey:@"msg"];
        } else {
            
            
            id myError = error.userInfo[@"NSUnderlyingError"];
            NSDictionary *dict = myError;
            if ([myError isKindOfClass:[NSError class]]) {
                dict = ((NSError *)myError).userInfo;
            }
            
            if ([dict isKindOfClass:[NSDictionary class]]) {
                errStr = [dict objectForKey:@"NSLocalizedDescription"];
            }
            if (errStr.length == 0) {
                errStr = @"系统错误";
            }
        }
        
        return errStr;
    }
    return nil;
}

+ (NSString *)md5:(NSString *)string {
    
    
    if (string.length == 0) {
        return nil;
    }
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return [result lowercaseStringWithLocale:[NSLocale currentLocale]];
}

@end
