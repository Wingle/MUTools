//
//  M3U8Playlist.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8SegmentInfo.h"


@interface M3U8Playlist : NSObject

@property (nonatomic, strong) NSMutableArray *segments;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) NSString *uuid;

- (id)initWithSegments:(NSArray *)segmentList;

- (M3U8SegmentInfo *)segmentAtIndex:(NSUInteger)index;

@end
