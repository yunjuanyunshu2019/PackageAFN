//
//  UserManager.h
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject
@property(nonatomic,copy)NSString *token;
+ (instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
