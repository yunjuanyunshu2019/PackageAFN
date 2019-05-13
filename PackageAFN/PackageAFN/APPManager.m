//
//  APPManager.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "APPManager.h"
#import "NetClient.h"

@implementation APPManager

+(instancetype)sharedManager {
    static APPManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[APPManager alloc] init];
    });
    return _sharedManager;
}











@end
