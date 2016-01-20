//
//  JZVideoPlayerView.m
//  aoyouHH
//
//  Created by 牛高航 on 15/5/29.
//  Copyright (c) 2015年 牛高航 . All rights reserved.
//

#import "JZVideoPlayerView.h"
#import "Header.h"

@interface JZVideoPlayerView ()
{
    id playbackObserver;
    
    UIView *loadView;
    UIActivityIndicatorView *activityIndicatorView;
    NSTimer *timer;
    BOOL viewIsShowing;
}

@end

@implementation JZVideoPlayerView

-(id)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        
        self.playerItem = [AVPlayerItem playerItemWithURL:contentURL];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        //创建播放器层
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame =CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height) ;
        //视频填充模式
        self.playerLayer.videoGravity=AVLayerVideoGravityResize;
        [self.layer addSublayer:self.playerLayer];
//        添加加载动画
        [self initLoadingView];
        
//     初始化播放，进度条，时间等视图
        [self initControlView];
        viewIsShowing = YES;
        
        //添加监听
        //给AVPlayerItem添加播放完成通知
        [self addNotification];
        [self addObserverToPlayerItem:self.playerItem];
        [self addProgressObserver];
        
    }
    return self;
}
/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 

-(void)thumbnailImageRequest:(CGFloat )timeBySecond{
    //创建URL
    NSURL *url=[self getNetworkUrl];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    //截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     //
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
}

*/
-(void)dealloc
{
    [self removeObserverToPlayerItem:self.playerItem];
    [self.player removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.playerLayer setFrame:frame];
}
-(void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        //
    }else{
        //
    }
}

-(void)play
{
    [self.player play];
    self.isPlaying = YES;
    [self.playBtn setSelected:YES];
}

-(void)pause
{
    [self.player pause];
    self.isPlaying = NO;
    [self.playBtn setSelected:NO];
}

-(void)stop
{
    
}
//菊花(旋转视图)
-(void)initLoadingView
{
    loadView = [[UIView alloc] initWithFrame:self.playerLayer.frame];
    
    NSLog(@"playerLayer:=====%f   %f",self.playerLayer.frame.size.width,self.playerLayer.frame.size.height);
    loadView.backgroundColor = [UIColor clearColor];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [activityIndicatorView setCenter:loadView.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView startAnimating];
    [loadView addSubview:activityIndicatorView];
    [self addSubview:loadView];
}
//初始化播放，进度条，时间等视图
-(void)initControlView
{
    int frameWidth = self.frame.size.width;
    int frameHeight = self.frame.size.height;
    
    //上面的遮罩
    self.playerHUDTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
    self.playerHUDTopView.image=[UIImage imageNamed:@"player_upBg.png"];
    self.playerHUDTopView.userInteractionEnabled=YES;
//    self.playerHUDTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.playerHUDTopView];
    
    //返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 44,44);
    [self.backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"sp_icon_back.png"] forState:UIControlStateNormal];
    [self.playerHUDTopView addSubview:self.backBtn];
    //标题
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, frameWidth-95, 34)];
    self.titleLab.text = @"";
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textColor = [UIColor whiteColor];
    [self.playerHUDTopView addSubview:self.titleLab];
    NSLog(@"-------%@",self.titleStr);
    
    self.logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(frameWidth-34, 10, 24,24)];
    self.logoImg.image=[UIImage imageNamed:@"play_logo.png"];
    [self.playerHUDTopView addSubview:self.logoImg];
    
    
    //下面的遮罩
    self.playerHUDBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frameHeight-44, frameWidth, 44)];
    self.playerHUDBottomView.image=[UIImage imageNamed:@"player_bottomBg.png"];
    self.playerHUDBottomView.userInteractionEnabled=YES;
//    self.playerHUDBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.playerHUDBottomView];
    
    
    //播放，暂停按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.playBtn addTarget:self action:@selector(OnPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setSelected:NO];
    [self.playBtn setImage:[UIImage imageNamed:@"miniplayer_bottom_pause.png"] forState:UIControlStateSelected];
    [self.playBtn setImage:[UIImage imageNamed:@"miniplayer_bottom_play.png"] forState:UIControlStateNormal];
    [self.playBtn setTintColor:[UIColor clearColor]];
    [self.playerHUDBottomView addSubview:self.playBtn];
    //全屏按钮
    self.zoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zoomBtn.frame = CGRectMake(frameWidth-34, 10, 24, 24);
    [self.zoomBtn addTarget:self action:@selector(OnZoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.zoomBtn setSelected:NO];
    [self.zoomBtn setImage:[UIImage imageNamed:@"zoomout.png"] forState:UIControlStateSelected];
    [self.zoomBtn setImage:[UIImage imageNamed:@"miniplayer_icon_fullsize.png"] forState:UIControlStateNormal];
    [self.zoomBtn setTintColor:[UIColor clearColor]];
    [self.playerHUDBottomView addSubview:self.zoomBtn];
    
    //缓冲进度条
    self.loadProgressView = [[UIProgressView alloc] init];
    self.loadProgressView.frame = CGRectMake(46, 17, frameWidth-90, 14);
    self.loadProgressView.progressViewStyle = UIProgressViewStyleBar;
    self.loadProgressView.progressTintColor =RGBA(61.0, 61.0, 61.0, 1.0);
    self.loadProgressView.backgroundColor = [UIColor darkGrayColor];
    self.loadProgressView.progress = 0;
    [self.playerHUDBottomView addSubview:self.loadProgressView];
    //播放进度条
    self.progressBar = [[UISlider alloc] init];
    self.progressBar.frame = CGRectMake(44, 11, frameWidth-90, 14);
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressBar addTarget:self action:@selector(progressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressBar setMinimumTrackTintColor:
     RGBA(242, 96, 0,1)];
    [self.progressBar setMaximumTrackTintColor:[UIColor clearColor]]; //设置成透明
    //    [self.progressBar trackRectForBounds:CGRectMake(0, 0, frameWidth-60, 5)];
    [self.progressBar setThumbTintColor:[UIColor clearColor]];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"account_cache_isplay"];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.progressBar setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.progressBar setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [self.playerHUDBottomView addSubview:self.progressBar];
    
    //播放时间
    self.playTime = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, 200, 20)];
    self.playTime.text = @"00:00:00/00:00:00";
    self.playTime.font = [UIFont systemFontOfSize:13];
    self.playTime.textAlignment = NSTextAlignmentLeft;
    self.playTime.textColor = [UIColor whiteColor];
    [self.playerHUDBottomView addSubview:self.playTime];
    
}

-(void)initPlayTime
{
    NSString *currentTime = [self getStringFromCMTime:self.player.currentTime];
    NSString *totalTime = [self getStringFromCMTime:self.player.currentItem.asset.duration];
    self.playTime.text = [NSString stringWithFormat:@"%@/%@",currentTime,totalTime];
    NSLog(@"totalTime:%@",totalTime);
}

//添加计时器，显示/隐藏播放栏
-(void)startTimer
{
    if (timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initHUDViewShowing:) userInfo:nil repeats:YES];
    }
}
-(void)stopTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)initHUDViewShowing:(NSTimer *)timer
{
    [self showHud:viewIsShowing];
}

-(void)showHud:(BOOL)showing
{
    __weak __typeof(self) weakself = self;
    if (showing)
    {//隐藏
        viewIsShowing = !showing;
        weakself.playerHUDTopView.hidden = YES;
        weakself.playerHUDBottomView.hidden = YES;
        [weakself stopTimer];
    }
    else
    {//显示
        
        viewIsShowing = !showing;
        weakself.playerHUDBottomView.hidden = NO;
        weakself.playerHUDTopView.hidden = NO;
        [weakself startTimer];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        NSLog(@"横屏");
        self.isFullScreen = YES;
        [self initLandscape];
    }
    else{
        NSLog(@"竖屏");
        self.isFullScreen = NO;
        [self initPortraint];
        
    }
}
//initLandscape与initPortraint里面一样
-(void)initLandscape{
    NSLog(@"====%f",self.playerLayer.frame.size.width);
    float frameWidth = self.frame.size.width;
    float frameHeight = self.frame.size.height;
    NSLog(@"横屏:width=%f   height=%f",frameWidth,frameHeight);
    self.playerHUDTopView.frame=CGRectMake(0, 0, frameWidth, 44);
    self.titleLab.frame=CGRectMake(44, 5, frameWidth-95, 34);
    self.logoImg.frame=CGRectMake(frameWidth-34, 10, 24, 24);
    self.playerHUDBottomView.frame = CGRectMake(0, frameHeight-44, frameWidth, 44);
    self.zoomBtn.frame = CGRectMake(frameWidth-34, 10, 24, 24);
    self.progressBar.frame = CGRectMake(44, 11, frameWidth-90, 14);
    self.loadProgressView.frame = CGRectMake(46, 17, frameWidth-90, 14);
}
//
-(void)initPortraint
{
     NSLog(@"====%f",self.playerLayer.frame.size.width);
    float frameWidth = self.playerLayer.frame.size.width;
    float frameHeight = self.playerLayer.frame.size.height;
    
    self.playerLayer.frame =CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height) ;
    
    NSLog(@"竖屏:width=%f   height=%f-----",frameWidth,frameHeight);
    self.playerHUDTopView.frame=CGRectMake(0, 0, frameWidth, 44);
    self.titleLab.frame=CGRectMake(44, 5, frameWidth-95, 34);
    self.logoImg.frame=CGRectMake(frameWidth-34, 10, 24, 24);
    self.playerHUDBottomView.frame = CGRectMake(0, frameHeight-44, frameWidth, 44);
    self.zoomBtn.frame = CGRectMake(frameWidth-34, 10, 24, 24);
    self.progressBar.frame = CGRectMake(44, 11, frameWidth-90, 14);
    self.loadProgressView.frame = CGRectMake(46, 17, frameWidth-90, 14);
}

//监听touch事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.playerLayer.frame, point))
    {
        [self showHud:viewIsShowing];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
}

#pragma mark - UI事件
/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 *  @param sender 全屏/非全屏按钮
 *  @param sender 返回按钮
 *  @param sender 播放进度条按钮
 
 */
-(void)OnPlayBtn:(UIButton *)sender{
    if (self.isPlaying)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

-(void)OnZoomBtn:(UIButton *)sender
{
    NSLog(@"全屏/非全屏");
    self.isFullScreen = !self.isFullScreen;
    if (self.isFullScreen)
    {
        [self.zoomBtn setSelected:YES];
    }
    else
    {
        [self.zoomBtn setSelected:NO];
    }
    [self.delegate playerViewZoomButtonClicked:self];
}

-(void)OnBackBtn:(UIButton *)sender
{
    if (self.isFullScreen)
    {
        self.isFullScreen = !self.isFullScreen;
        [self.delegate playerViewZoomButtonClicked:self];
    }
    else
    {
        [self.delegate JZOnBackBtn];
    }
}

-(void)progressBarChanged:(UISlider *)sender
{
    if (self.isPlaying)
    {
        [self.player pause];
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value*(double)self.player.currentItem.asset.duration.value/(double)self.player.currentItem.asset.duration.timescale, self.player.currentTime.timescale);
    [self.player seekToTime:seekTime];
}

-(void)progressBarChangeEnded:(UISlider *)sender{
    [self startTimer];
    if (self.isPlaying)
    {
        [self.player play];
    }
}


#pragma mark - 通知
/**
 *  添加播放器通知
 */

-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}
/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成");
}

#pragma mark - 监控

/**
 *  给播放器添加进度更新
 */

-(void)addProgressObserver{
    __weak __typeof(self) weakself = self;
    AVPlayerItem *playerItem = self.player.currentItem;
    NSLog(@"//添加播放进度条更新");
    playbackObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(playerItem.duration);
        //        NSLog(@"当前已经播放%.2fs。",current);
        //更新进度条
        float progress = current/total;
        weakself.progressBar.value = progress;
        NSString *currentTime = [weakself getStringFromCMTime:weakself.player.currentTime];
        NSString *totalTime = [weakself getStringFromCMTime:playerItem.duration];
        weakself.playTime.text = [NSString stringWithFormat:@"%@/%@",currentTime,totalTime];
    }];
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监控缓冲区大小
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self performSelectorInBackground:@selector(initPlayTime) withObject:nil];
}
/**
 *  移除KVO观察
 */
-(void)removeObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

#pragma mark - 观察视频播放各个监听触发
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {//播放状态
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusFailed:
                NSLog(@"播放失败");
                [loadView setHidden:NO];
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"正在播放...视频中长度为：%f",CMTimeGetSeconds(self.playerItem.duration));
                [loadView setHidden:YES];
                break;
            default:
                NSLog(@"default:");
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){//缓冲
        NSArray *array = self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        
        float durationTime = CMTimeGetSeconds([[self.player currentItem] duration]);//总时间
//        NSLog(@"共缓冲：%.2f，总时长为:%f",totalBuffer,durationTime);
        [self.loadProgressView setProgress:totalBuffer/durationTime animated:YES];
        
        if (self.playerIsBuffering && self.isPlaying) {
            [self.player play];
            self.playerIsBuffering = NO;
        }
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if(self.player.currentItem.playbackBufferEmpty){
            NSLog(@"缓冲区为空");
            self.playerIsBuffering = YES;
        }else{
            NSLog(@"缓冲区不为空======");
        }
    }else{
        NSLog(@"++++++++++");
    }
}


-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hours = mins / 60.0f;
    int secs = fmodf(currentSeconds, 60.0);
    mins = fmodf(mins, 60.0f);
    
    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    
    
    return [NSString stringWithFormat:@"%@:%@:%@", hoursString,minsString, secsString];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
