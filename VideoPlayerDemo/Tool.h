//
//  Tool.h
//  oschina
//
//  Created by 牛高航 on 15/8/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tool.h"

@interface Tool : NSObject


+(void)initWithNavViewWith:(NSString *)titleName selfView:(UIViewController *)selfView;

+(void)initWithNavViewWith:(NSString *)titleName left:(NSString *)nameLeft right:(NSString *)nameRight selfView:(UIViewController *)selfView;


@end
