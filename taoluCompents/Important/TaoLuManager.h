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



@property (nonatomic, assign)NSInteger taskId;
@property (nonatomic, strong)NSArray *classNames;
@property (nonatomic, assign)BOOL isEnglish;

+ (TaoLuManager *)shareManager;
+ (void)startTaskInViewController:(UIViewController *)viewController;
+ (void)resetTaskId;
+ (void)initShareSDK;
@end
