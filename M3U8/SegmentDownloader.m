//
//  SegmentDownloader.m
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "SegmentDownloader.h"
#import "ASIHTTPRequest.h"

@interface SegmentDownloader ()
@property (nonatomic, strong) ASIHTTPRequest *request;

@end

@implementation SegmentDownloader

- (id)initWithUrl:(NSString *) strUrl
      andFilePath:(NSString *) path
      andFileName:(NSString *) fileName {
    
    self = [super init];
    if(self) {
        _downloadUrl = strUrl;
        _fileName = fileName;
        _filePath = path;
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)
                                objectAtIndex:0];
        NSString *fileDir = [[docDir stringByAppendingPathComponent:kPathDownload]
                            stringByAppendingPathComponent:_filePath];
        
        NSString *downloadingFileName = [fileDir stringByAppendingPathComponent:
                                         [_fileName stringByAppendingString:kTextDownloadingFileSuffix]];
        _tmpFileName = downloadingFileName;
        
        BOOL isDir = NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        if(!([fm fileExistsAtPath:fileDir isDirectory:&isDir] && isDir)) {
            [fm createDirectoryAtPath:fileDir withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
        }
        _progress = 0.0f;
        _status = MUDownloadTaskStatusStoped;
    }
    return  self;
}

-(void)start {
    LOG(@"download segment start, fileName = %@,url = %@",self.fileName,self.downloadUrl);
    NSURL *Url = [NSURL URLWithString:[self.downloadUrl
                                       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.request = [ASIHTTPRequest requestWithURL:Url];
    [self.request setTemporaryFileDownloadPath: self.tmpFileName];
    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
    [self.request setDownloadDestinationPath:[saveTo stringByAppendingPathComponent:self.fileName]];
    [self.request setDelegate:self];
    self.request.allowResumeForFileDownloads = YES;
    [self.request setNumberOfTimesToRetryOnTimeout:2];
    [self.request startAsynchronous];
    self.status = MUDownloadTaskStatusRunning;
}

-(void)stop {
    LOG(@"download stoped");
    if(self.request && (self.status == MUDownloadTaskStatusRunning)) {
        self.request.delegate = nil;
        [self.request cancelAuthentication];
    }
    self.status = MUDownloadTaskStatusStoped;
}

-(void)clean
{
    LOG(@"download clean");
    if(self.request && (self.status == MUDownloadTaskStatusRunning)) {
        self.request.delegate = nil;
        [self.request cancelAuthentication];
        [self.request removeTemporaryDownloadFile];
        NSError *Error = nil;
        if (![ASIHTTPRequest removeFileAtPath:[self.request downloadDestinationPath] error:&Error]) {
            LOG(@"clean file err:%@",Error);
        }
    }
    self.status = MUDownloadTaskStatusStoped;
    self.progress = 0.0f;
}

-(void)dealloc {
    [self stop];
}


#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    LOG(@"download finished!");
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(segmentDownloadFinished:)]) {
        [self.delegate segmentDownloadFinished:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *err = aRequest.error;
    if (err.code != 3)
    {
        [self stop];
        LOG(@"Download failed.");
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(segmentDownloadFailed:)]) {
            [self.delegate segmentDownloadFailed:self];
        }
    }
}



@end
