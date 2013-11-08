//
//  VideoDownloader.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadDelegate.h"

@class M3U8Playlist;

@interface VideoDownloader : NSObject<SegmentDownloadDelegate>

@property (nonatomic, weak) id<VideoDownloadDelegate> delegate;
@property (nonatomic, strong) M3U8Playlist *playlist;
@property (nonatomic, assign) CGFloat downLoadProgress;

- (id)initWithM3U8List:(M3U8Playlist*)list;

- (void)startDownloadVideo;

- (void)pauseDownloadVideo;

- (void)cancelDownloadVideo;

@end
