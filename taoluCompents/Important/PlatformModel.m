//
//  PlatformModel.m
//  TaoLu2
//
//  Created by yuebin on 16/11/18.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "PlatformModel.h"

@implementation PlatformModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        NSArray *allKeys = [dic allKeys];
        if ([allKeys containsObject:@"key"]) {
            self.key = dic[@"key"];
        }
        if ([allKeys containsObject:@"secret"]) {
            self.secreat = dic[@"secret"];
        }
    }
    return self;
}

@end
