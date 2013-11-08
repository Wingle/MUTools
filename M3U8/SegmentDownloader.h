//
//  SegmentDownloader.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadDelegate.h"

@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, MUDownloadTaskStatus) {
    MUDownloadTaskStatusRunning = 0,
    MUDownloadTaskStatusStoped = 1,
};

#define kPathDownload @"Downloads"
#define kTextDownloadingFileSuffix @"_etc"

@interface SegmentDownloader : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *tmpFileName;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, weak) id<SegmentDownloadDelegate> delegate;
@property (nonatomic, assign) MUDownloadTaskStatus status;
@property (nonatomic, assign) CGFloat progress;

- (void)start;
- (void)stop;
- (void)clean;
- (id)initWithUrl:(NSString*) strUrl
      andFilePath:(NSString *) path
      andFileName:(NSString *) fileName;

@end
