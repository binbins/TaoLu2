//
//  VChead.h
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#ifndef VChead_h
#define VChead_h

#define YBTEST  //稳定之后注释掉
#ifdef YBTEST
#define YBLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define YBLog(format, ...)
#endif

#define TAOLU_ORDER @"taoluTaskOrder"
#define CONFIGJSON [[TaoLuManager returnTaoLuJSON]objectForKey:@"res"]
#define SHARESDK_ID [[CONFIGJSON objectForKey:@"configInfo"]objectForKey:@"mobKey"]
#define SHARESDK_REURL [[CONFIGJSON objectForKey:@"configInfo"]objectForKey:@"redirectUri"]
#define SHARESDK_PLATFORMS [[CONFIGJSON objectForKey:@"configInfo"]objectForKey:@"platformKey"]

#define SHARESDK_KEY_WEIBO [[SHARESDK_PLATFORMS objectForKey:@"weiBo"]objectForKey:@"key"]
#define SHARESDK_SECREAT_WEIBO [[SHARESDK_PLATFORMS objectForKey:@"weiBo"]objectForKey:@"secreat"]

#define SHARESDK_KEY_WEIXIN [[SHARESDK_PLATFORMS objectForKey:@"weiXin"]objectForKey:@"key"]
#define SHARESDK_SECREAT_WEIXIN [[SHARESDK_PLATFORMS objectForKey:@"weiXin"]objectForKey:@"secreat"]

#define SHARESDK_KEY_QQ [[SHARESDK_PLATFORMS objectForKey:@"QQ"]objectForKey:@"key"]
#define SHARESDK_SECREAT_QQ [[SHARESDK_PLATFORMS objectForKey:@"QQ"]objectForKey:@"secreat"]

#define SHARESDK_KEY_FACEBOOK [[SHARESDK_PLATFORMS objectForKey:@"faceBook"]objectForKey:@"key"]
#define SHARESDK_SECREAT_FACEBOOK [[SHARESDK_PLATFORMS objectForKey:@"faceBook"]objectForKey:@"secreat"]

#define SHARESDK_KEY_TWITTER [[SHARESDK_PLATFORMS objectForKey:@"twitter"]objectForKey:@"key"]
#define SHARESDK_SECREAT_TWITTER [[SHARESDK_PLATFORMS objectForKey:@"twitter"]objectForKey:@"secreat"]

#define ISCHINESE [[[NSLocale preferredLanguages] firstObject] isEqualToString:@"zh-Hans-CN"]
#define LOCAL_JSON_NAME ISCHINESE?@"localJson_CN":@"localJson_EN"
#endif /* VChead_h */

#import "PasteViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "FollowViewController.h"
#import "NewArrivalViewController.h"    //这几个vc做好之后可以删掉

#import "UILabel+Extension.h"


