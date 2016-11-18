//
//  TaoLuManager.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//


#define AppVerName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppVerCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppBundleID [[NSBundle mainBundle] bundleIdentifier]

#define SysName [[[UIDevice currentDevice] systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysVersion [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysModel [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CurrentLanguageAd [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @""

#define AppGeneralInfoDict @{@"platform": @"ios", @"package" : AppBundleID, @"appvername":AppVerName, @"appvercode":AppVerCode, @"sys_name":SysName, @"sys_ver":SysVersion, @"sys_model":SysModel, @"sys_language":CurrentLanguageAd, @"taolu_version":@"1.0"}


#import <UIKit/UIKit.h>
#import "TaoLuManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


#import <TencentOpenAPI/TencentOAuth.h>     //腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"   //微信SDK头文件
#import "WeiboSDK.h"    //新浪微博SDK头文件

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import <AFNetworking.h>
#import "AlertUtils.h"

@implementation TaoLuManager


static dispatch_once_t predict;
static TaoLuManager *manager = nil;

#pragma mark - 内部方法
+ (void)initShareSDK {
    
    [manager setPlatformModel];
    [ShareSDK registerApp:SHARESDK_ID
     
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
                 [appInfo SSDKSetupSinaWeiboByAppKey:manager.weiboModel.key
                                           appSecret:manager.weiboModel.Secreat
                                         redirectUri:SHARESDK_REURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:manager.weixinModel.key
                                       appSecret:manager.weixinModel.key];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:manager.QQModel.key
                                      appKey:manager.QQModel.Secreat
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 [appInfo        SSDKSetupTwitterByConsumerKey:manager.twitterModel.key
                                                consumerSecret:manager.twitterModel.Secreat
                                                   redirectUri:SHARESDK_REURL];    //回调地址
                 break;
                 
             default:
                 break;
         }
     }];
}

- (void)setPlatformModel{
    NSArray *platforms = SHARESDK_PLATFORMS;
    if(platforms != nil){
        for (NSDictionary *d in platforms) {
            NSString *name = [d objectForKey:@"platform"];
            [manager setModel:name WithDic:d];
        }
    }
}

- (void)setModel:(NSString *)name WithDic:(NSDictionary *)dic{
    if([name isEqualToString:@"qq"]){
        manager.QQModel = [[PlatformModel alloc]init];
        manager.QQModel.key = [dic objectForKey:@"key"];
        manager.QQModel.Secreat = [dic objectForKey:@"secreat"];
        return;
    }
    if([name isEqualToString:@"weixin"]){
        manager.weixinModel = [[PlatformModel alloc]init];
        manager.weixinModel.key = [dic objectForKey:@"key"];
        manager.weixinModel.Secreat = [dic objectForKey:@"secreat"];
        return;
    }
    if([name isEqualToString:@"weibo"]){
        manager.weiboModel = [[PlatformModel alloc]init];
        manager.weiboModel.key = [dic objectForKey:@"key"];
        manager.weiboModel.Secreat = [dic objectForKey:@"secreat"];
        return;
    }
    if([name isEqualToString:@"twitter"]){
        manager.twitterModel = [[PlatformModel alloc]init];
        manager.twitterModel.key = [dic objectForKey:@"key"];
        manager.twitterModel.Secreat = [dic objectForKey:@"secreat"];
        return;
    }
    if([name isEqualToString:@"facebook"]){
        manager.facebookModel = [[PlatformModel alloc]init];
        manager.facebookModel.key = [dic objectForKey:@"key"];
        manager.facebookModel.Secreat = [dic objectForKey:@"secreat"];
        return;
    }
}

+ (TaoLuManager *)shareManager {
    
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        YBLog(@"查看路径 -->%@",NSHomeDirectory());
        manager.classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
        for (int i=0; i<manager.classNames.count; i++) {
            if (![userDefaults boolForKey:manager.classNames[i]]) {
                [userDefaults setObject:@NO forKey:manager.classNames[i]];
            }
        }
    });
    
    return manager;
}
+ (void)updateConfig {

    for (NSString *language in [NSLocale preferredLanguages]) {
        YBLog(@"需要注意可能有问题，语言列表-->%@<--",language);
    }
    AFHTTPSessionManager *sessionManager;
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [sessionManager GET:@"http://192.168.0.20:9001/" parameters:AppGeneralInfoDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [TaoLuManager shareManager].taoLuJson = responseObject;
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:LOCAL_JSON_NAME];
        [self initShareSDK];
        [self setNewOrderClassNames];
        YBLog(@"网络获取成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([TaoLuManager shareManager].taoLuJson) return ;
        
        NSDictionary *localJson = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_JSON_NAME];
        if(localJson){
            [self shareManager].taoLuJson = localJson;
            [self initShareSDK];
            [self setNewOrderClassNames];
        }else {
            //都没有的话，[TaoLuManager shareManager].taoLuJson 的值是nil，根据这个控制弹出
            YBLog(@"当前是空");
            [TaoLuManager shareManager].taskState(taskNone);
        }
    }];

}

+ (void)setNewOrderClassNames{
    NSMutableArray *newClassNames = [NSMutableArray array];
    NSArray *arr = [CONFIGJSON objectForKey:@"taskpriority"];
    for (int i =0; i < arr.count; i++) {
        [newClassNames addObject:[self changeName:arr[i]]];
    }
    if(arr.count == newClassNames.count){
        [TaoLuManager shareManager].classNames = newClassNames; //也加了容错处理
    }
}

+ (NSString *)changeName:(NSString *)name{
    if([name isEqualToString:@"sharetask"]){
        return CLASSNAME_SHARE;
    }
    if([name isEqualToString:@"goodtask"]){
        return CLASSNAME_GOOD;
    }
    if([name isEqualToString:@"followtask"]){
        return CLASSNAME_FOLLOW;
    }
    if([name isEqualToString:@"downloadtask"]){
        return CLASSNAME_DOWNLOAD;
    }
    YBLog(@"字符串不符合------");
    return nil;
}

+ (NSDictionary *)returnTaoLuJSON {
    return [TaoLuManager shareManager].taoLuJson;
}
#pragma mark - unity调用 等同

extern "C" {
    
    void __startTask(){
        
        if ([[TaoLuManager shareManager] taoLuJson] == nil) {
            [TaoLuManager shareManager].taskState(taskNone);
            return;
        }
        
        //根据任务的有无，来判断是否执行完毕
        NSString *currentClassName;
        NSArray *newClassNames = [TaoLuManager shareManager].classNames;
        for (int i=0; i<newClassNames.count; i++) {
            NSLog(@"%@",newClassNames[i]);
            if (![[[NSUserDefaults standardUserDefaults]objectForKey:newClassNames[i]]boolValue]) {
                currentClassName = newClassNames[i];
                //让utils执行
                [AlertUtils StartTaskWithClassName:currentClassName];
                break;
            }
        }
        
        if(currentClassName == nil){
            [TaoLuManager shareManager].taskState(taskAllFinish); //空就是没有了
        }else{
            [AlertUtils StartTaskWithClassName:currentClassName];
            currentClassName = nil;
        }
            }

}

extern "C" {
    
    void __resetTask(){
        NSLog(@"xcode 原生执行事件 置为NO");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *names = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
        for (int i =0; i<names.count; i++) {
            [userDefaults setObject:@NO forKey:names[i]];
        }
        
    }
    
}


+ (void)startTaskInViewController:(UIViewController *)viewController {
    
    if ([[TaoLuManager shareManager] taoLuJson] == nil) {
        [TaoLuManager shareManager].taskState(taskNone);
        return;
    }
    
    //根据任务的有无，来判断是否执行完毕
    NSString *currentClassName;
    NSArray *newClassNames = [TaoLuManager shareManager].classNames;
    for (int i=0; i<newClassNames.count; i++) {
//        NSLog(@"%@",newClassNames[i]);
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:newClassNames[i]]boolValue]) {
            currentClassName = newClassNames[i];
            [AlertUtils StartTaskWithClassName:currentClassName];
            break;
        }
    }
    
    if(currentClassName == nil){
          [TaoLuManager shareManager].taskState(taskAllFinish); //空就是没有了
    }else{
        [AlertUtils StartTaskWithClassName:currentClassName];
        currentClassName = nil;
    }
    
    
}

+ (void)resetTask{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *names = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
    for (int i =0; i<names.count; i++) {
        [userDefaults setObject:@NO forKey:names[i]];
    }
}


#pragma mark - 导入unity后打开
/*
+ (void)sendMsgtoUnityWhenGetResult:(TaskState)state{
    
    switch (state) {
        case taskCancle:
            YBLog(@"任务取消");
            [UILabel showStats:@"任务取消" atView:[UIApplication sharedApplication].keyWindow];
            UnitySendMessage("Main Camera", "GetIosResult", "取消");
            break;
        case taskFaild:
            YBLog(@"任务失败");
            UnitySendMessage("Main Camera", "GetIosResult", "失败");
            break;
        case taskSuccees:
            YBLog(@"任务成功");
            [UILabel showStats:@"任务完成" atView:[UIApplication sharedApplication].keyWindow];
            UnitySendMessage("Main Camera", "GetIosResult", "成功");
            break;
        case taskAllFinish:
            YBLog(@"mobi");
            UnitySendMessage("Main Camera", "GetIosResult", "mobi");
            break;
        case taskNone:
            YBLog(@"无数据");
            UnitySendMessage("Main Camera", "GetIosResult", "无数据");
        default:
            break;
    }
    
}
*/
@end
