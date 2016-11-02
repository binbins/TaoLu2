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
    [TaoLuManager startTaskInViewController:self];
}

- (IBAction)changeLanguage:(UISwitch *)sender {
    NSLog(@"%@",sender.on?@"英语":@"中文");
    [TaoLuManager shareManager].isEnglish = sender.on;
}


- (IBAction)reset:(UIButton *)sender {
    [TaoLuManager resetTaskId];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
