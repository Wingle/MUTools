//
//  SegmentCacheManager.m
//  MUTools
//
//  Created by Wingle Wong on 11/8/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "SegmentCacheManager.h"

@implementation SegmentCacheManager

+ (NSString *)cacheRootDirectory {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)
                        objectAtIndex:0];
    NSString *cacheRootDir = [docDir stringByAppendingPathComponent:kPathDownload];
    return cacheRootDir;
}

+ (BOOL)deleteCacheRootDirectory {
    NSString *cacheRootDir = [[self class] cacheRootDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheRootDir]) {
        NSError *removeError = nil;
        if (![fileManager removeItemAtPath:cacheRootDir error:&removeError]) {
            LOG(@"delete file=%@ err, err is %@",cacheRootDir,removeError);
            return NO;
        }
    }
    return YES;
}

@end
