//
//  ViewController.m
//  MUTools
//
//  Created by Wingle Wong on 11/7/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (strong, nonatomic) M3U8Handler *muHandler;
@property (strong, nonatomic) VideoDownloader *downLoader;
@property (nonatomic, copy) NSString *m3u8_url;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.statueLabel setText:@"No Progress"];
    self.progressView.progress = 0.0f;
    
    self.muHandler =  [[M3U8Handler alloc] init];
    self.muHandler.delegate = self;
    
    self.m3u8_url = @"http://v.youku.com/player/getRealM3U8/vid/XNjIyNzI3OTQw/type/video.m3u8";
    
    if([self.m3u8_url hasSuffix:@".m3u8"]) {
        [self.muHandler praseUrl:self.m3u8_url];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downLoadVideo:(id)sender {
    if(self.downLoader)
    {
        [self.downLoader startDownloadVideo];
    }
    [self.statueLabel setText:@"Downloading..."];
    
}
- (IBAction)pauseDownLoadVideo:(id)sender {
    
}
- (IBAction)playVideo:(id)sender {
    
    NSString *strUrl = [NSString stringWithFormat:@"http://127.0.0.1:12345/%d/movie.m3u8",[self.m3u8_url hash]];
    NSLog(@"strurl = %@",strUrl);
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:strUrl]]];
    
}


- (void)videoDownloaderFinished:(VideoDownloader *) videoDownloader {
    [self.statueLabel setText:@"Download Finished"];
}

-(void)praseM3U8Finished:(M3U8Handler*) handler {
    NSLog(@"praseM3U8Finished");
    self.downLoader = [[VideoDownloader alloc]initWithM3U8List:handler.playlist];
    self.downLoader.delegate = self;
    [self.downLoader addObserver:self
                      forKeyPath:@"downLoadProgress"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.progressView setProgress:self.downLoader.downLoadProgress animated:YES];
}

@end
