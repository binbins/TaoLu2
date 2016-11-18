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

#define CONFIGJSON [[TaoLuManager returnTaoLuJSON]objectForKey:@"res"]
#define TASKLIST [CONFIGJSON objectForKey:@"tasklist"]
#define SHARESDK_ID [[CONFIGJSON objectForKey:@"configinfo"]objectForKey:@"mobkey"]
#define SHARESDK_REURL [[CONFIGJSON objectForKey:@"configinfo"]objectForKey:@"redirecturi"]
#define SHARESDK_PLATFORMS [[CONFIGJSON objectForKey:@"configinfo"]objectForKey:@"platformkey"]


#define ISCHINESE [[[NSLocale preferredLanguages] firstObject] isEqualToString:@"zh-Hans-CN"]
#define LOCAL_JSON_NAME ISCHINESE?@"localJson_CN":@"localJson_EN"
#endif /* VChead_h */

#import "PasteViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "FollowViewController.h"
#import "NewArrivalViewController.h"    //这几个vc做好之后可以删掉

#import "UILabel+Extension.h"


