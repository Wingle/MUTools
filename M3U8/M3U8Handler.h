//
//  M3U8Handler.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class M3U8Playlist;
@class M3U8Handler;

@protocol M3U8HandlerDelegate <NSObject>

@optional
- (void)praseM3U8Finished:(M3U8Handler *)handler;
- (void)praseM3U8Failed:(M3U8Handler *)handler;

@end


@interface M3U8Handler : NSObject

@property (nonatomic, weak) id<M3U8HandlerDelegate> delegate;
@property (nonatomic, strong) M3U8Playlist *playlist;

- (void)praseUrl:(NSString*)urlstr;

@end

/* m3u8文件格式示例
 
 #EXTM3U
 #EXT-X-TARGETDURATION:30
 #EXT-X-VERSION:2
 #EXT-X-DISCONTINUITY
 #EXTINF:10,
 http://f.youku.com/player/getMpegtsPath/st/flv/fileid/03000201004F4BC6AFD0C202E26EEEB41666A0-C93C-D6C9-9FFA-33424A776707/ipad0_0.ts?KM=14eb49fe4969126c6&start=0&end=10&ts=10&html5=1&seg_no=0&seg_time=0
 #EXTINF:20,
 http://f.youku.com/player/getMpegtsPath/st/flv/fileid/03000201004F4BC6AFD0C202E26EEEB41666A0-C93C-D6C9-9FFA-33424A776707/ipad0_1.ts?KM=14eb49fe4969126c6&start=10&end=30&ts=20&html5=1&seg_no=1&seg_time=0
 #EXTINF:20,
 http://f.youku.com/player/getMpegtsPath/st/flv/fileid/03000201004F4BC6AFD0C202E26EEEB41666A0-C93C-D6C9-9FFA-33424A776707/ipad0_2.ts?KM=14eb49fe4969126c6&start=30&end=50&ts=20&html5=1&seg_no=2&seg_time=0
 #EXTINF:20,
 http://f.youku.com/player/getMpegtsPath/st/flv/fileid/03000201004F4BC6AFD0C202E26EEEB41666A0-C93C-D6C9-9FFA-33424A776707/ipad0_3.ts?KM=14eb49fe4969126c6&start=50&end=70&ts=20&html5=1&seg_no=3&seg_time=0
 #EXTINF:24,
 http://f.youku.com/player/getMpegtsPath/st/flv/fileid/03000201004F4BC6AFD0C202E26EEEB41666A0-C93C-D6C9-9FFA-33424A776707/ipad0_4.ts?KM=14eb49fe4969126c6&start=70&end=98&ts=24&html5=1&seg_no=4&seg_time=0
 #EXT-X-ENDLIST
 */

