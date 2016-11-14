//
//  AlertUtils.h
//  TaoLu2
//
//  Created by 张帆 on 16/11/8.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertUtils : NSObject



+ (void)commentAlert;

+ (void)sameToCoustom:(NSInteger)index;

+ (void)shareAlert;

+ (void)downloadAlert;


+ (NSArray *)getUITypeArr;
@end
