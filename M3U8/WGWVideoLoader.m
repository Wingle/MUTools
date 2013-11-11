//
//  WGWVideoLoader.m
//  MUTools
//
//  Created by Wingle Wong on 11/8/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "WGWVideoLoader.h"
#import "SegmentCacheManager.h"

@implementation WGWVideoLoader

+ (instancetype)shareVideoLoader {
    static id instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}


- (NSURL *)videoM3u8UrlForURL:(NSString *) aURL {
    if (!aURL) {
        return nil;
    }
    NSString *rootDir = [SegmentCacheManager cacheRootDirectory];
    NSString *fileDir = [rootDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%u",[aURL hash]]];
    NSString *m3u8file = [fileDir stringByAppendingPathComponent:kM3u8FileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = nil;
    if ([fileManager fileExistsAtPath:m3u8file]) {
        NSString *m3u8Link = [NSString stringWithFormat:@"http://127.0.0.1:12345/%u/%@",[aURL hash],kM3u8FileName];
        url = [NSURL URLWithString:m3u8Link];
    }else {
        url = [NSURL URLWithString:aURL];
    }
    return url;
}

@end
