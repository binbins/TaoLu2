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

+ (TaoLuManager *)shareManager;
+ (void)startTaskInViewController:(UIViewController *)viewController;
+ (void)resetTaskId;
@end
