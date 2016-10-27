//
//  ViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/26.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "ViewController.h"
#import "VChead.h"
#import "TaoLuManager.h"


@interface ViewController ()
@property(nonatomic, strong)UIAlertController *pasteAlert;

@end

@implementation ViewController

- (UIAlertController *)pasteAlert {

    if (_pasteAlert == nil) {
        _pasteAlert = [UIAlertController alertControllerWithTitle:@"✔️复制成功" message:@"粘贴至输入框即可" preferredStyle:UIAlertControllerStyleAlert];
        
        [_pasteAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = @"这个游戏太好玩了，实在打不过，快来帮我呀 https://skf/dhs/sjdl";
            
          
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去告诉好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //跳转到APP
        }];
        [_pasteAlert addAction:confirm];
    }
    return _pasteAlert;
}


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

- (IBAction)reset:(UIButton *)sender {
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
