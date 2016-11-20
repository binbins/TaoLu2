//
//  TaoLuManager.h
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#define GOODTASK_DIC [TASKLIST objectForKey:@"goodtask"]
#define FOLLOWTASK_DIC [TASKLIST objectForKey:@"followtask"]
#define DOWNLOADTASK_DIC [TASKLIST objectForKey:@"downloadtask"]
#define SHARETASK_DIC [TASKLIST objectForKey:@"sharetask"]

#define CLASSNAME_SHARE @"ShareViewController"
#define CLASSNAME_GOOD @"CommentViewController"
#define CLASSNAME_FOLLOW @"FollowViewController"
#define CLASSNAME_DOWNLOAD @"NewArrivalViewController"
#import <Foundation/Foundation.h>
#import "VChead.h"
#import "PlatformModel.h"

@interface TaoLuManager : NSObject

typedef enum {
    taskSuccees,
    taskCancle,
    taskFaild,
    taskNone,
    taskClose,
    taskAllFinish
    
}TaskState;

typedef void(^OnFinishTask) (TaskState state);
@property (nonatomic, strong)OnFinishTask taskState;
@property (nonatomic, strong)NSArray *classNames;
@property (nonatomic, strong)NSDictionary *taoLuJson;
@property (nonatomic, strong)PlatformModel *QQModel, *weixinModel, *weiboModel, *facebookModel, *twitterModel;

+ (TaoLuManager *)shareManager;
+ (void)startTask;
+ (void)resetTask;
+ (void)initShareSDK;
+ (NSDictionary *)returnTaoLuJSON;
+ (void)updateConfig;
+ (void)sendMsgtoUnityWhenGetResult:(TaskState)state;   //内有调用unity的方法
@end
