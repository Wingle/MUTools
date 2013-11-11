//
//  M3U8Handler.m
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "M3U8Handler.h"
#import "M3U8SegmentInfo.h"
#import "M3U8Playlist.h"

#define EXTINF_STR_LENGTH   [@"#EXTINF:" length]

@interface M3U8Handler ()
@property (nonatomic, copy) NSString *originalStrUrl;

@end

@implementation M3U8Handler

- (void)praseUrl:(NSString *)urlstr {
    if(![urlstr hasSuffix:@".m3u8"]) {
        LOG(@"Invalid url");
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(praseM3U8Failed:)]) {
            [self.delegate praseM3U8Failed:self];
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *data = [NSString stringWithContentsOfURL:url
                                          usedEncoding:&encoding
                                                 error:&error];
    if(data == nil) {
        LOG(@"data is nil");
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(praseM3U8Failed:)]) {
            [self.delegate praseM3U8Failed:self];
        }
        return;
    }
    
    NSMutableArray *segments = [NSMutableArray arrayWithCapacity:0];
    NSString *remainData = data;
    NSRange segmentRange = [remainData rangeOfString:@"#EXTINF:"];
    while (segmentRange.location != NSNotFound) {
        M3U8SegmentInfo * segment = [[M3U8SegmentInfo alloc] init];
        
        // Get segment duration
        NSRange commaRange = [remainData rangeOfString:@","];
        NSString *value = [remainData substringWithRange:
                           NSMakeRange(segmentRange.location +
                                       EXTINF_STR_LENGTH,
                                       commaRange.location -
                                       (segmentRange.location +
                                        EXTINF_STR_LENGTH))];
        
        segment.duration = [value integerValue];
        
        // get segment url
        remainData = [remainData substringFromIndex:commaRange.location];
        NSRange linkRangeBegin = [remainData rangeOfString:@"http"];
        NSRange linkRangeEnd = [remainData rangeOfString:@"#"];
        NSString *linkurl = [remainData substringWithRange:
                             NSMakeRange(linkRangeBegin.location,
                                         linkRangeEnd.location -
                                         linkRangeBegin.location)];
        segment.locationUrl = linkurl;
        
        // add segment to segment list
        [segments addObject:segment];
        
        // new sub remainData
        remainData = [remainData substringFromIndex:linkRangeEnd.location];
        segmentRange = [remainData rangeOfString:@"#EXTINF:"];
    }
    
    M3U8Playlist *thePlaylist = [[M3U8Playlist alloc] initWithSegments:segments];
    thePlaylist.uuid = [NSString stringWithFormat:@"%u",[urlstr hash]];
    self.playlist = thePlaylist;
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(praseM3U8Finished:)]) {
        [self.delegate praseM3U8Finished:self];
    }
}




@end
