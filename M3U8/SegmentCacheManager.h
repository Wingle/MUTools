//
//  SegmentCacheManager.h
//  MUTools
//
//  Created by Wingle Wong on 11/8/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPathDownload   @"Downloads"
#define kM3u8FileName   @"movie.m3u8"

@interface SegmentCacheManager : NSObject

+ (NSString *)cacheRootDirectory;
+ (BOOL)deleteCacheRootDirectory;

@end
