//
//  AlertUtils.m
//  TaoLu2
//
//  Created by 张帆 on 16/11/8.
//  Copyright © 2016年 adesk. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AlertUtils.h"
#import "TaoLuManager.h"


@implementation AlertUtils

/*
    说明：原生分享支持 标题，链接，本地图片 
    有网址的时候，qq会自动用爬虫去获取，此时图片，标题无效
 */

+ (void)commentAlert{

    UIAlertController *commentAlert = [UIAlertController alertControllerWithTitle:[GOODTASK_DIC objectForKey:@"title"] message:[GOODTASK_DIC objectForKey:@"nativeSecondTitle"] preferredStyle:UIAlertControllerStyleAlert];
    
    //创建动作
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:[GOODTASK_DIC objectForKey:@"nativeCancleBtnText"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [TaoLuManager shareManager].taskState(taskCancle);
    }]; //取消
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[GOODTASK_DIC objectForKey:@"BtnTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *iTunesLink = [GOODTASK_DIC objectForKey:@"openUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        [commentAlert dismissViewControllerAnimated:YES completion:nil];
        [TaoLuManager shareManager].taskState(taskSuccees);
    }];
    
    //添加动作
    [commentAlert addAction:cancle];
    [commentAlert addAction:confirm];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commentAlert animated:YES completion:nil];
}

+ (void)sameToCoustom:(NSInteger)index {
    
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow ]rootViewController];
    UIViewController *vc = [[NSClassFromString([TaoLuManager shareManager].classNames[index]) alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController presentViewController:vc animated:YES completion:nil];

}
+ (void)shareAlert{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shot.png"];
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (screenShot) {  //保存到本地，除非截屏失败，一般情况下是用不到的
        [UIImagePNGRepresentation(screenShot) writeToFile:path atomically:YES];
        
    }
    
    NSString *string = [SHARETASK_DIC objectForKey:@"title"];
    NSString *stringUrl = [[SHARETASK_DIC objectForKey:@"shareContents"]objectForKey:@"shareUrl"];
    NSURL *URL = [NSURL URLWithString:stringUrl];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL, screenShot]
                                      applicationActivities:nil];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:activityViewController animated:YES completion:nil];

}
+ (void)downloadAlert {

    UIAlertController *commentAlert = [UIAlertController alertControllerWithTitle:[DOWNLOADTASK_DIC objectForKey:@"title"] message:[DOWNLOADTASK_DIC objectForKey:@"appName"] preferredStyle:UIAlertControllerStyleAlert];
    
    //创建动作
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:[DOWNLOADTASK_DIC objectForKey:@"nativeCancleBtnText"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [TaoLuManager shareManager].taskState(taskCancle);
    }]; //取消
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[DOWNLOADTASK_DIC objectForKey:@"btnTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *iTunesLink = [DOWNLOADTASK_DIC objectForKey:@"downloadUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        [commentAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //添加动作
    [commentAlert addAction:cancle];
    [commentAlert addAction:confirm];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commentAlert animated:YES completion:nil];
    
}

+ (void)StartTaskWithClassName:(NSString *)classname{

    if([self isCustom:classname]){  //自定义
        UIViewController *rootvc = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *vc = [[NSClassFromString(classname) alloc]init];
        [vc setDefinesPresentationContext:YES];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [rootvc presentViewController:vc animated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:classname];//任务++
    }else{  //原生
        [self useNativeUI:classname];
    }
}
#pragma mark - 私有方法

+ (void)useNativeUI:(NSString *)classname{
    if([classname isEqualToString:CLASSNAME_SHARE]){
        [self shareAlert];
    }
    if([classname isEqualToString:CLASSNAME_GOOD]){
        [self commentAlert];
    }
    if([classname isEqualToString:CLASSNAME_DOWNLOAD]){
        [self downloadAlert];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:classname];
}

+ (BOOL)isCustom:(NSString *)classname{
    
    if([classname isEqualToString:CLASSNAME_SHARE]){
        return [[SHARETASK_DIC objectForKey:@"isCoustomUI"]boolValue];
    }
    if([classname isEqualToString:CLASSNAME_GOOD]){
        return [[GOODTASK_DIC objectForKey:@"isCoustomUI"]boolValue];
    }
//    if([classname isEqualToString:CLASSNAME_FOLLOW]){
//        return YES;
//    }
    if([classname isEqualToString:CLASSNAME_DOWNLOAD]){
        return [[DOWNLOADTASK_DIC objectForKey:@"isCoustomUI"]boolValue];
    }
    
    return YES; //默认自定义
}




@end
