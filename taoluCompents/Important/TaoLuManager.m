//
//  TaoLuManager.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TaoLuManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface TaoLuManager ()

@end

@implementation TaoLuManager

static dispatch_once_t predict;
static TaoLuManager *manager = nil;


+ (TaoLuManager *)shareManager {
    
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        manager.isEnglish = NO;
        if (![userDefaults boolForKey:TAOLU_ORDER]) {   //首次下载
            [userDefaults setObject:@(0) forKey:TAOLU_ORDER];
        }
        manager.taskId = [[userDefaults objectForKey:TAOLU_ORDER]integerValue];
        NSLog(@"查看userdefaults %@------",NSHomeDirectory());
        manager.classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
    });
    return manager;
}

+ (void)startTaskInViewController:(UIViewController *)viewController{
    
    NSInteger order = [self shareManager].taskId;
    if (order < [self shareManager].classNames.count) {
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

+ (void)initShareSDK {
    [ShareSDK registerApp:@"172db5f736dec"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
                
            default:
                break;
        }
    }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
    {
        
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"3352061377"
                                          appSecret:@"b8c69754f262e2bc5523e9369e9e28db"
                                        redirectUri:@"http://s.adesk.com/game666six/index.html"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx2a9ef2489f76f887"
                                      appSecret:@"cb5be5ebee7b259a718192fcb66e597f"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105634813"
                                     appKey:@"kRTSX5rC2Rpf7FiA"
                                   authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeTwitter:
                [appInfo        SSDKSetupTwitterByConsumerKey:@"l2hkM6gGTJYwRWZsNCnO2X5tL" consumerSecret:@"aYlIZfR8slIZTnL7GXaKGOpaO3KTWLzj0zW4OC3TzabaDnjbBW"        redirectUri:@"http://s.adesk.com/game666six/index.html"];    //回调地址
                break;
                
            default:
                break;
        }
    }];
}
- (void)setTaskId:(NSInteger)taskId {   //重写set方法
    _taskId = taskId;
    [[NSUserDefaults standardUserDefaults]setObject:@(taskId) forKey:TAOLU_ORDER];
    NSLog(@"当前taskId:%ld",taskId);
}



@end
