//
//  UserManager.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "UserManager.h"
#define kToken @"token"

@implementation UserManager

@synthesize token = _token;

static UserManager *_sharedManager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[UserManager alloc] init];
    });
    return _sharedManager;
}


// token
- (void)setToken:(NSString *)token {
    
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token {
    
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    }
    return _token;
}




@end
