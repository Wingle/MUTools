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

#define kTextDownloadingFileSuffix @"_etc"

@interface SegmentDownloader : NSObject


@property (nonatomic, weak) id<SegmentDownloadDelegate> delegate;
@property (nonatomic, assign) MUDownloadTaskStatus status;

- (void)start;
- (void)stop;
- (void)clean;
- (id)initWithUrl:(NSString*) strUrl
      andFilePath:(NSString *) path
      andFileName:(NSString *) fileName;

@end
