//
//  PasteViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "PasteViewController.h"

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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startAction:(UIButton *)sender {
    
    [[UIPasteboard generalPasteboard]setString:self.pasteTextView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // textview 设置文本
    [[UIPasteboard generalPasteboard]setString:self.pasteTextView.text];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//    [textView resignFirstResponder];
//    return YES;
//}

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
