//
//  NetAPIManager.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/13.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "NetAPIManager.h"
#import "NetClient.h"




@implementation NetAPIManager
+(void)getPhoneCode: (NSString*)phone block:(void (^)(NSString *result,NSError *error))block {
    NSDictionary *paramsDict = @{@"phone" : phone};
    
    [[NetClient sharedClient] requestJsonDataWithPath:@"/mobile/getPhoneCode" withParams:paramsDict needCache:NO withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        
        if (block) {
            block(data,error);
        }
        NSLog(@"%@",data);
        
    }];
     
     }
@end
