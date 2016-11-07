//
//  PasteViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "PasteViewController.h"
#import "TaoLuManager.h"

@interface PasteViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pasteTitleFirst;
@property (weak, nonatomic) IBOutlet UILabel *pasteTitleSecond;
@property (weak, nonatomic) IBOutlet UITextView *pasteTextView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation PasteViewController

+ (instancetype)returnInstance {
    PasteViewController *vc = [[PasteViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [TaoLuManager shareManager].taskState(taskCancle);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startAction:(UIButton *)sender {
    
    //这里添加打开应用的类型
    [[UIPasteboard generalPasteboard]setString:self.pasteTextView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // textview 设置文本
    if (self.pasteDic) {
        self.pasteTitleFirst.text = [self.pasteDic objectForKey:@"title1"];
        self.pasteTitleSecond.text = [self.pasteDic objectForKey:@"title2"];
        self.pasteTextView.text = [self.pasteDic objectForKey:@"textViewText"];
        [self.startBtn setTitle:[self.pasteDic objectForKey:@"startBtnTitle"] forState:UIControlStateNormal];
    }
    
    [[UIPasteboard generalPasteboard]setString:self.pasteTextView.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
