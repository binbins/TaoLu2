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
@property(nonatomic, strong)NSArray *classNames;

@end

@implementation TaoLuManager

- (NSArray *)classNames{
    if (_classNames == nil) {
        _classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController",@"PasteViewController"];
    }
    return _classNames;
}

+ (instancetype)shareManager {

    TaoLuManager *manager = nil;
    
    if (manager == nil) {
        manager = [[self alloc]init];
        manager.taskId = 0;
    }
    return manager;
}

+ (void)startTaskInViewController:(UIViewController *)viewController{
    TaoLuManager *manager = [self shareManager];
    if (manager.taskId <5) {
        NSLog(@"执行事件%ld",manager.taskId);
        manager.taskId++;
    }else{
        NSLog(@"交给unity执行");
    }
    
    
}

@end
