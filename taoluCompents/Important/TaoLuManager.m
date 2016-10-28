//
//  TaoLuManager.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TaoLuManager.h"


@interface TaoLuManager ()

@end

@implementation TaoLuManager

static dispatch_once_t predict;
static TaoLuManager *manager = nil;


+ (TaoLuManager *)shareManager {
    
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        if (![userDefaults boolForKey:TAOLU_ORDER]) {   //首次下载
            [userDefaults setObject:@(0) forKey:TAOLU_ORDER];
        }
        manager.taskId = [[userDefaults objectForKey:TAOLU_ORDER]integerValue];
        NSLog(@"去检索：沙盒路径%@------",NSHomeDirectory());
        manager.classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController",@"PasteViewController"];
    });
    return manager;
}

+ (void)startTaskInViewController:(UIViewController *)viewController{
    
    NSInteger order = [self shareManager].taskId;
    if (order < 5) {
        UIViewController *vc = [[NSClassFromString(manager.classNames[order]) alloc]init];
        [vc setDefinesPresentationContext:YES];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [viewController presentViewController:vc animated:YES completion:nil];
        [self shareManager].taskId++;   //回调结束之后再去增加任务数，防止奖励bug
        
    }else{
        NSLog(@"交给unity执行");
    }
}

+ (void)resetTaskId{
    [self shareManager].taskId = 0;
}

- (void)setTaskId:(NSInteger)taskId {   //set方法里让设置文件也跟着变
    _taskId = taskId;
    [[NSUserDefaults standardUserDefaults]setObject:@(taskId) forKey:TAOLU_ORDER];
    NSLog(@"当前taskId:%ld",taskId);
}



@end
