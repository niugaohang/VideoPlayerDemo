//
//  JZVideoPlayerView.h
//  aoyouHH
//
//  Created by 牛高航 on 15/8/27.
//  Copyright (c) 2015年 牛高航 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class JZVideoPlayerView;

@protocol JZPlayerViewDelegate <NSObject>

@optional
-(void)playerViewZoomButtonClicked:(JZVideoPlayerView *)view;
-(void)JZOnBackBtn;

@end

@interface JZVideoPlayerView : UIView

@property(nonatomic, assign) id<JZPlayerViewDelegate> delegate;





//avplayer
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSURL *contentURL;

@property(nonatomic, assign) BOOL isFullScreen;
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL playerIsBuffering;

//
@property(nonatomic, strong) UIButton *playBtn;//播放，暂停按钮
@property(nonatomic, strong) UIButton *zoomBtn;//全屏，不全屏按钮
@property(nonatomic, strong) UISlider *progressBar;//播放进度条
@property(nonatomic, strong) UIProgressView *loadProgressView;//缓存进度条
@property(nonatomic, strong) UILabel *playTime;//已播放时间
@property(nonatomic, strong) UILabel *playTotalTime;//总时间

@property(nonatomic, strong) UIButton *backBtn;//返回按钮
@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) UILabel  *titleLab;//标题
@property(nonatomic, strong) UIImageView  *logoImg;//logo


@property(nonatomic, strong) UIImageView *playerHUDBottomView;
@property(nonatomic, strong) UIImageView *playerHUDTopView;







/**
 *  NSURL初始化
 */
-(id)initWithFrame:(CGRect)frame contentURL:(NSURL *)contentURL;
/**
 *  播放
 */
-(void)play;
/**
 *  暂停
 */
-(void)pause;
/**
 *  停止
 */
-(void)stop;

@end
