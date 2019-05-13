//
//  NetAPIManager.h
//  PackageAFN
//
//  Created by YTKJ on 2019/5/13.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetAPIManager : NSObject
+(void)getPhoneCode: (NSString*)phone block:(void (^)(NSString *result,NSError *error))block;
@end

NS_ASSUME_NONNULL_END
