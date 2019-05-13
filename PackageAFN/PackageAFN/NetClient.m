//
//  NetClient.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "NetClient.h"
#import "UserManager.h"
#import "PackageDefine.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "PackageUtil.h"
#import "FileManager.h"
#import <YYKit.h>

@implementation NetClient

static NetClient *_sharedClient = nil;
+(instancetype)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient =   [[NetClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLStr]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
    return _sharedClient;
}

- (id)initWithBaseUrl:(NSURL*)url {
    self = [super initWithBaseURL:url];
    self.securityPolicy.validatesDomainName = NO;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 30;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/javascript",@"text/json",@"text/html",nil];
    ((AFJSONResponseSerializer*)self.responseSerializer).removesKeysWithNullValues = YES;
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    if ([UserManager sharedManager].token) {
        [self.requestSerializer setValue:[UserManager sharedManager].token forHTTPHeaderField:@"token"];
    }
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"plateform"];
    self.securityPolicy.allowInvalidCertificates = YES;
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                      needCache:(BOOL)needCache
                 withMethodType:(RequestMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block {

    NSLog(@"aa%@",block);
    
    [self requestJsonDataWithPath:aPath withParams:params needCache:needCache withMethodType:method autoShowError:autoShowError retryingNumberOfTimes:nil error:nil progress:nil andBlock:block];
}





-(void)requestJsonDataWithPath:(NSString*)apath
                    withParams:(NSDictionary*)params
                     needCache:(BOOL)needCache
                withMethodType:(RequestMethod)method
                 autoShowError:(BOOL)autoShowError
         retryingNumberOfTimes:(NSNumber*)ntimes
        error:(NSError*)error
        progress:(void (^)(NSProgress* error))progress
                      andBlock:(void (^)(id data, NSError *error))block {
    
    CFAbsoluteTime startTime =  CFAbsoluteTimeGetCurrent();
    if (!apath || apath.length <=0) {
        if (block){
            NSError *error = [NSError errorWithDomain:baseURLStr code:-1 userInfo:@{@"msg":@"系统错误，请稍后重试"}];
            block(nil,error);
        }
    }
    
    apath = [apath stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableString *localpath = [apath mutableCopy];
    if (params) {
        [localpath appendString:params.description];
    }
    
    if (ntimes && ntimes.integerValue <= 0) {
        if (autoShowError) {
            [PackageUtil showToast:@"系统错误"];
        }
        id responseObject = nil;
        if ( needCache) {
            responseObject = [FileManager loadResponseWithPath:localpath ];
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = nil;
            }
        }
        if (block) {
            block(responseObject[@"result"],error);
        }
        return;
    }
    switch (method) {
        case Get:{
            @weakify(self);
            [self GET:apath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                @strongify(self);
                 [self successWithResponse:responseObject aPath:apath localPath:localpath needCache:needCache autoShowError:autoShowError block:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              @strongify(self);
                [self requestJsonDataWithPath:apath withParams:params needCache:needCache withMethodType:method autoShowError:autoShowError retryingNumberOfTimes:@(ntimes.integerValue - 1) error:error progress:progress andBlock:block];
                
            }];
            
            break;
        }
        case Post:{
            @weakify(self);
            [self POST:apath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                @strongify(self);
                [self successWithResponse:responseObject aPath:apath localPath:localpath needCache:needCache autoShowError:autoShowError block:block];

                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 @strongify(self);
                [self requestJsonDataWithPath:apath withParams:params needCache:needCache withMethodType:method autoShowError:autoShowError retryingNumberOfTimes:@(ntimes.integerValue - 1) error:error progress:progress andBlock:block];
    
            }];
            break;
        }
        default:
            break;
    }
    
    
}
    
-(void)successWithResponse:(id)responseObject aPath:(NSString *)aPath localPath:(NSString *)localPath needCache:(BOOL)needCache autoShowError:(BOOL)autoShowError block:(void (^)(id data, NSError *error))block {
    id error = [self handleResponse:responseObject autoShowError:autoShowError];
    if (error) {
        if (needCache) {
            responseObject = [FileManager loadResponseWithPath:localPath];
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = nil;
            }
        }
    } else {
        if (needCache && [responseObject isKindOfClass:[NSDictionary class]]) {
            [FileManager saveResponseData:responseObject toPath:localPath];
        }
    }
    if (block) {
        NSLog(@"%@",responseObject);
        block(responseObject[@"data"], error);
    }
}

#pragma mark -错误处理
// 网络请求成功 中的失败处理
- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
    
    NSInteger status = [[responseJSON objectForKey:@"status"] integerValue];
    
    if (status != 0) {
        
        NSInteger errcode = [[responseJSON objectForKey:@"errcode"] integerValue];
        error = [NSError errorWithDomain:baseURLStr code:errcode userInfo:responseJSON];
        if (errcode == 500) {//用户未登录
           
        
        }else{
            //错误提示
            if (autoShowError) {
                [PackageUtil showToast:[PackageUtil tipFromError:error]];
            }
        }
    }
    return error;
}



@end
