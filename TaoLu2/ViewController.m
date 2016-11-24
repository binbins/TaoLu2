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
    [TaoLuManager startTask];

}




- (IBAction)reset:(UIButton *)sender {
    [TaoLuManager resetTask];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [TaoLuManager shareManager].taskState = ^(TaskState state){
        
        switch (state) {
            case TaskCancle:
                YBLog(@"任务取消");
                break;
            case TaskFaild:
                YBLog(@"任务失败");
                break;
            case TaskClose:
            YBLog(@"后台关闭套路任务");
            break;
            case TaskSuccees:
                YBLog(@"任务成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [UILabel showStats:@"task succeed" atView:[UIApplication sharedApplication].keyWindow];
            });
                break;
            case TaskAllFinish:
                YBLog(@"套路任务结束，交给mobi");
                break;
            case TaskNone:
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
