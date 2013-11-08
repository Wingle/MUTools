//
//  M3U8Playlist.m
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "M3U8Playlist.h"

@implementation M3U8Playlist

- (id)initWithSegments:(NSArray *)segmentList
{
    self = [super init];
    if(self)
    {
        _segments = [NSMutableArray arrayWithArray:segmentList];
        _length = [segmentList count];
    }
    return self;
}

- (M3U8SegmentInfo *)segmentAtIndex:(NSUInteger)index
{
    if(index < self.length) {
        return (M3U8SegmentInfo *)[self.segments objectAtIndex:index];
    }else {
        return nil;
    }
}

@end
