//
//  WGWVideoLoader.h
//  MUTools
//
//  Created by Wingle Wong on 11/8/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGWVideoLoader : NSObject

+ (instancetype)shareVideoLoader;

- (NSURL *)videoM3u8UrlForURL:(NSString *) aURL urlDoesExisted:(BOOL *) isExisted;

@end
