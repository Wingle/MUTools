//
//  DownloadDelegate.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SegmentDownloader;

@protocol SegmentDownloadDelegate <NSObject>

@optional
- (void)segmentDownloadFinished:(SegmentDownloader *) segmentDownloader;
- (void)segmentDownloadFailed:(SegmentDownloader *) segmentDownloader;

@end


@class VideoDownloader;

@protocol VideoDownloadDelegate <NSObject>

@optional
- (void)videoDownloaderFinished:(VideoDownloader *) videoDownloader;
- (void)videoDownloaderFailed:(VideoDownloader *) videoDownloader;

@end
