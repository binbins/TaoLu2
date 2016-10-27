//
//  TaoLuManager.h
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoLuManager : NSObject


@property (nonatomic, assign)NSInteger taskId;

+ (instancetype)shareManager;
+ (void)startTaskInViewController:(UIViewController *)viewController;

@end
