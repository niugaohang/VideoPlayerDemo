//
//  Tool.m
//  oschina
//
//  Created by 牛高航 on 15/8/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#ifdef    RKL_PREPEND_TO_METHODS
#define RKL_METHOD_PREPEND(x) _RKL_CONCAT(RKL_PREPEND_TO_METHODS, x)
#else  // RKL_PREPEND_TO_METHODS
#define RKL_METHOD_PREPEND(x) x
#endif // RKL_PREPEND_TO_METHODS
#define NSMaxiumRange         ((NSRange){.location=                   0UL, .length=    NSUIntegerMax})


#import "Tool.h"
#import "Header.h"
@implementation Tool

+(void)initWithNavViewWith:(NSString *)titleName selfView:(UIViewController *)selfView
{
    selfView.view.backgroundColor=RGBA(235.0, 235.0, 235.0, 1);
    //    导航条
    if (IsIOS7)
    {
        selfView.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    selfView.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [selfView.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    BOOL isTpng = [titleName hasSuffix:@"png"];
    if (isTpng)
    {
        UIImageView *titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:titleName]];
        selfView.navigationItem.titleView=titleImg;
        [selfView.navigationController.navigationBar setBarTintColor:RGBA(35.0, 131.0, 221.0, 1.0)];
    }
    else
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        titleLabel.textColor = [UIColor whiteColor];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = titleName;
        
        selfView.navigationItem.titleView = titleLabel;
        
        [selfView.navigationController.navigationBar setBarTintColor:RGBA(35.0, 131.0, 221.0, 1.0)];
        
        [selfView.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    }

}

+(void)initWithNavViewWith:(NSString *)titleName left:(NSString *)nameLeft right:(NSString *)nameRight selfView:(UIViewController *)selfView
{
    selfView.view.backgroundColor=RGBA(235.0, 235.0, 235.0, 1);
    //    导航条
    if (IsIOS7)
    {
        selfView.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    if (nameRight)
    {
        BOOL isPng = [nameRight hasSuffix:@"png"];
        if (isPng)
        {
            UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:nameRight] style:UIBarButtonItemStylePlain target:selfView action:@selector(rightBtnClick)];
            
            rightBtnItem.tintColor=[UIColor whiteColor];
            
            selfView.navigationItem.rightBarButtonItem = rightBtnItem;
        }
        else
        {
            UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:nameRight style:UIBarButtonItemStylePlain target:selfView action:@selector(rightBtnClick)];
            
            rightBtnItem.tintColor=[UIColor whiteColor];
            
            selfView.navigationItem.rightBarButtonItem = rightBtnItem;
        }
    }
    else
    {
        
        
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title=nameLeft;
    
    backItem.imageInsets =  UIEdgeInsetsMake(15, 0, 0, 0);
    selfView.navigationItem.backBarButtonItem = backItem;
    
    
    selfView.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [selfView.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

   
    BOOL isTpng = [titleName hasSuffix:@"png"];
    if (isTpng)
    {
        UIImageView *titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:titleName]];
        selfView.navigationItem.titleView=titleImg;
        [selfView.navigationController.navigationBar setBarTintColor:RGBA(35.0, 131.0, 221.0, 1.0)];
    }
    else
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        titleLabel.textColor = [UIColor whiteColor];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = titleName;
        
        selfView.navigationItem.titleView = titleLabel;
        
        [selfView.navigationController.navigationBar setBarTintColor:RGBA(35.0, 131.0, 221.0, 1.0)];
        
        [selfView.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    }
    
}
//点击右边按钮
-(void)rightBtnClick
{
//    [SVProgressHUD dismiss];

}



@end












