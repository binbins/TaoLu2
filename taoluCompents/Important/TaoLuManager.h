//
//  TaoLuManager.h
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VChead.h"

@interface TaoLuManager : NSObject

typedef enum {
    taskSuccees,
    taskCancle,
    taskFaild,
    taskNone,
    taskAllFinish
    
}TaskState;

typedef void(^OnFinishTask) (TaskState state);
@property (nonatomic, strong)OnFinishTask taskState;
@property (nonatomic, assign)NSInteger taskIndex;
@property (nonatomic, strong)NSArray *classNames;
@property (nonatomic, strong)NSDictionary *taoLuJson;

+ (TaoLuManager *)shareManager;
+ (void)startTaskInViewController:(UIViewController *)viewController onFinish:(OnFinishTask)finishState;
+ (void)resetTaskIndex;
+ (void)initShareSDK;
+ (NSDictionary *)returnTaoLuJSON;
+ (void)updateConfig;
@end
