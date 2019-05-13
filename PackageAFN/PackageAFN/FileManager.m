//
//  FileManager.m
//  PackageAFN
//
//  Created by YTKJ on 2019/5/7.
//  Copyright © 2019年 YTKJ. All rights reserved.
//

#import "FileManager.h"
#import "PackageDefine.h"
#import "PackageUtil.h"

@implementation FileManager

+ (id)loadResponseWithPath:(NSString*)requesetPath {
    NSString *abslutePath = [NSString stringWithFormat:@"%@.plist", [self pathInResponseCacheDirectory:requesetPath ]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
}

+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath {
    
    NSString *abslutePath = [NSString stringWithFormat:@"%@.plist", [self pathInResponseCacheDirectory:requestPath]];
    return [data writeToFile:abslutePath atomically:YES];
}


+ (NSString *)pathInResponseCacheDirectory:(NSString *)fileName {
    
    return [getFileDir(kPath_ResponseCache) stringByAppendingPathComponent:[PackageUtil md5:fileName]];
}

NSString *getFileDir(NSString *fileDirName) {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *fileFolder = [documentDir stringByAppendingPathComponent:fileDirName];
    
    BOOL isDir = NO;
    BOOL existed = [filemgr fileExistsAtPath:fileFolder isDirectory:&isDir];
    
    if (existed && isDir) {
        return fileFolder;
    }
    
    NSError *error = nil;
    if(![filemgr createDirectoryAtPath:fileFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        fileFolder = nil;
    }
    return fileFolder;
}
@end
