//
//  VideoDownloader.m
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "VideoDownloader.h"
#import "M3U8Playlist.h"
#import "SegmentDownloader.h"

@interface VideoDownloader () {
    NSUInteger tototalDownloading;
}

@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, assign) BOOL bDownloading;

- (NSString *)generateLocalM3U8file;

@end

@implementation VideoDownloader

- (id)initWithM3U8List:(M3U8Playlist *)list {
    self = [super init];
    if(self)
    {
        _playlist = list;
        _downLoadProgress = 0.0;
    }
    return  self;
}

- (void)startDownloadVideo {
    LOG(@"start download video");
    if(self.downloadArray == nil) {
        self.downloadArray = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i = 0; i < self.playlist.length; i++) {
            NSString *filename = [NSString stringWithFormat:@"id%d",i];
            M3U8SegmentInfo *segment = [self.playlist segmentAtIndex:i];
            SegmentDownloader *sgDownloader = [[SegmentDownloader alloc]
                                               initWithUrl:segment.locationUrl
                                               andFilePath:self.playlist.uuid
                                               andFileName:filename];
            sgDownloader.delegate = self;
            [self.downloadArray addObject:sgDownloader];
        }
    }
    
    tototalDownloading = [self.downloadArray count];
    
    for(SegmentDownloader* obj in self.downloadArray) {
        [obj start];
    }
    
    self.bDownloading = YES;
}

- (void)cleanDownloadFiles
{
    LOG(@"cleanDownloadFiles");

    for(NSInteger i = 0; i < self.playlist.length; i++) {
        NSString *filename = [NSString stringWithFormat:@"id%d",i];
        NSString *tmpfilename = [filename stringByAppendingString:kTextDownloadingFileSuffix];
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *savePath = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.playlist.uuid];
        NSString *fullpath = [savePath stringByAppendingPathComponent:filename];
        NSString *fullpath_tmp = [savePath stringByAppendingPathComponent:tmpfilename];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:fullpath]) {
            NSError *removeError = nil;
            if (![fileManager removeItemAtPath:fullpath error:&removeError]) {
                NSLog(@"delete file=%@ err, err is %@",fullpath,removeError);
            }
        }
        
        if ([fileManager fileExistsAtPath:fullpath_tmp]) {
            NSError *removeError = nil;
            if (![fileManager removeItemAtPath:fullpath_tmp error:&removeError]) {
                NSLog(@"delete file=%@ err, err is %@",fullpath_tmp,removeError);
            }
        }
    }
    
}


- (void)pauseDownloadVideo {
    LOG(@"pause Download Video");
    if(self.bDownloading && self.downloadArray) {
        for(SegmentDownloader *obj in self.downloadArray) {
            [obj stop];
        }
        self.bDownloading = NO;
    }
}

- (void)cancelDownloadVideo {
    LOG(@"cancel download video");
    if(self.bDownloading && self.downloadArray)
    {
        for(SegmentDownloader *obj in self.downloadArray) {
            [obj clean];
        }
    }
    [self cleanDownloadFiles];
}

- (NSString*)generateLocalM3U8file {
    if(self.playlist) {
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.playlist.uuid];
        NSString *fullpath = [saveTo stringByAppendingPathComponent:@"movie.m3u8"];
        LOG(@"createLocalM3U8file:%@",fullpath);
        
        // M3U8 head file
        NSString* head = @"#EXTM3U\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:2\n#EXT-X-DISCONTINUITY\n";
        NSString* segmentPrefix = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@/",self.playlist.uuid];
        
        // segment
        for(NSInteger i = 0; i < self.playlist.length; i++) {
            NSString* filename = [NSString stringWithFormat:@"id%d",i];
            M3U8SegmentInfo* segInfo = [self.playlist segmentAtIndex:i];
            NSString* length = [NSString stringWithFormat:@"#EXTINF:%d,\n",segInfo.duration];
            NSString* url = [segmentPrefix stringByAppendingString:filename];
            head = [NSString stringWithFormat:@"%@%@%@\n",head,length,url];
        }
        
        // ending
        NSString* end = @"#EXT-X-ENDLIST";
        head = [head stringByAppendingString:end];
        NSMutableData *writer = [[NSMutableData alloc] init];
        [writer appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        
        BOOL bSucc =[writer writeToFile:fullpath atomically:YES];
        if(bSucc) {
            NSLog(@"create m3u8file succeed; fullpath:%@, content:%@",fullpath,head);
            return  fullpath;
        }else {
            NSLog(@"create m3u8file failed");
            return  nil;
        }
    }
    return nil;
}


#pragma mark - SegmentDownloadDelegate
- (void)segmentDownloadFailed:(SegmentDownloader *) segmentDownloader {
    LOG(@"a segment Download Failed");
    if(self.delegate && [self.delegate respondsToSelector:@selector(videoDownloaderFailed:)]) {
        [self.delegate videoDownloaderFailed:self];
    }
}

- (void)segmentDownloadFinished:(SegmentDownloader *) segmentDownloader {
    LOG(@"a segment Download Finished");
    [self.downloadArray removeObject:segmentDownloader];
    
    NSInteger remainCount = [self.downloadArray count];
    self.downLoadProgress = 1.0 - (CGFloat) remainCount/tototalDownloading;
    if(remainCount == 0) {
        // create new m3u8 file
        [self generateLocalM3U8file];
        self.downLoadProgress = 1.0f;
        LOG(@"all the segments downloaded. video download finished");
        if(self.delegate && [self.delegate respondsToSelector:@selector(videoDownloaderFinished:)]) {
            [self.delegate videoDownloaderFinished:self];
        }
    }
    
    LOG(@"downLoadProgress = %f",self.downLoadProgress);
}




@end
