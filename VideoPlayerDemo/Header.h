//
//  Header.h
//  VideoPlayerDemo
//
//  Created by 牛高航 on 15/8/31.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#ifndef VideoPlayerDemo_Header_h
#define VideoPlayerDemo_Header_h

#import "Tool.h"
#import "JZVideoPlayerView.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "PlayerViewController.h"
#import "AFNetworking/AFNetworking/AFNetworking.h"

#define USER_D [NSUserDefaults standardUserDefaults]
#define FILE_M [NSFileManager defaultManager]
#define VIEW_WIDTH      [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define DAPEICOLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KBarColor [UIColor colorWithRed:244/255.0 green:94/255.0 blue:95/255.0 alpha:1]  //bar的颜色
#define RGB(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];


#define DAPEICOLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KBarColor [UIColor colorWithRed:244/255.0 green:94/255.0 blue:95/255.0 alpha:1]  //bar的颜色
#define RGB(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
//// 2.获得RGB颜色

#endif
