//
//  PlayerViewController.m
//  VideoPlayerDemo
//
//  Created by 牛高航 on 15/8/31.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//
#define PLAY_X  15
#import "PlayerViewController.h"
#import "Header.h"

@interface PlayerViewController ()<JZPlayerViewDelegate>
{
    JZVideoPlayerView *_jzPlayer;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [Tool initWithNavViewWith:@"视频列表" selfView:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    获取视频连接
    [self getMoviePlayUrl];

    
//    禁止横屏
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isFullScreen = NO;
//设置信号栏
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isFullScreen = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark - 获取视频链接
-(void)getMoviePlayUrl
{
    NSString *UrlStr =@"http://v4.music.126.net/20160121154204/8317d4eda94e592dcad1d8b76c85d5fa/web/cloudmusic/MSBmMDAkZGQjIjk0IWEwMA==/mv/393006/b8ab2b91c7ba9ca847ec07be12e1bc44.mp4";
        
    NSLog(@"==11====%@",UrlStr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSURL *url = [NSURL URLWithString:UrlStr];
        _jzPlayer = [[JZVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, VIEW_WIDTH, 210) contentURL:url];
        _jzPlayer.titleStr=@"";
        _jzPlayer.delegate = self;
        [self.view addSubview:_jzPlayer];
        [_jzPlayer play];
        
    });
    
}
#pragma mark - JZPlayerViewDelegate
-(void)playerViewZoomButtonClicked:(JZVideoPlayerView *)view
{
//    禁止横屏
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //强制横屏
    NSLog(@"222222");
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
        {
            appDelegate.isFullScreen = NO;
            _jzPlayer.frame = CGRectMake(0,20, self.view.frame.size.height, 210);
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        else
        {
            appDelegate.isFullScreen = YES;
            
            _jzPlayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
            [_jzPlayer play];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;//
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}
-(void)JZOnBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
