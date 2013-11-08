//
//  ViewController.h
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M3U8Handler.h"
#import "VideoDownloader.h"

@interface ViewController : UIViewController <M3U8HandlerDelegate, VideoDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
