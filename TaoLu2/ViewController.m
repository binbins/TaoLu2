//
//  ViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/26.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "ViewController.h"
#import "TaoLuManager.h"


@interface ViewController ()

@end

@implementation ViewController




- (IBAction)shareAction:(UIButton *)sender {
    ShareViewController *shareVC = [ShareViewController returnInstance];
    [self presentViewController:shareVC animated:NO completion:nil];
}

- (IBAction)commentAction:(UIButton *)sender {
    CommentViewController *comentVC = [CommentViewController returnInstance];
    [self presentViewController:comentVC animated:NO completion:nil];
}

- (IBAction)followAction:(UIButton *)sender {
    FollowViewController *comentVC = [FollowViewController returnInstance];
    [self presentViewController:comentVC animated:NO completion:nil];
}

- (IBAction)pasteAction:(UIButton *)sender {
//    [self presentViewController:self.pasteAlert animated:YES completion:nil];
    PasteViewController *pasteVC = [PasteViewController returnInstance];
    [self presentViewController:pasteVC animated:NO completion:nil];
}

- (IBAction)newArrivalAction:(UIButton *)sender {
    NewArrivalViewController *pasteVC = [NewArrivalViewController returnInstance];
    [self presentViewController:pasteVC animated:NO completion:nil];
}

- (IBAction)noAction:(UIButton *)sender {
}


- (IBAction)getTask:(UIButton *)sender {
    [TaoLuManager startTaskInViewController:nil];

}




- (IBAction)reset:(UIButton *)sender {
    [TaoLuManager resetTask];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [TaoLuManager shareManager].taskState = ^(TaskState state){
        
        switch (state) {
            case taskCancle:
                YBLog(@"任务取消");
                [UILabel showStats:@"任务取消" atView:[UIApplication sharedApplication].keyWindow];
                break;
            case taskFaild:
                YBLog(@"任务失败");
                break;
            case taskSuccees:
                YBLog(@"任务成功");
                [UILabel showStats:@"任务完成" atView:[UIApplication sharedApplication].keyWindow];
                break;
            case taskAllFinish:
                YBLog(@"套路任务结束，交给mobi");
                break;
            case taskNone:
                YBLog(@"没有获取到任务，交给mobi");
                break;
                
            default:
                break;
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
