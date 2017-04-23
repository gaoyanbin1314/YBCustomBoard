//
//  ViewController.m
//  YBCustomKeyBoard
//
//  Created by 高艳彬 on 2017/4/23.
//  Copyright © 2017年 YBKit. All rights reserved.
//

#import "ViewController.h"
#import "YBCustomBoard.h"

@interface ViewController (){

    UITextField             *_idTextFieldView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 启用系统键盘调用通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
    
    // textFieldView
    
    _idTextFieldView = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    _idTextFieldView.placeholder  = @"自定义键盘启动";
    _idTextFieldView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_idTextFieldView];
    
    UITextField *systemTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    systemTextField.placeholder  = @"系统键盘启动";
    systemTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:systemTextField];
    
}


#pragma mark --- NSNotificationEvent
- (void)handleKeyboardWillShow:(NSNotification *)notification{
    
    if (_idTextFieldView.isFirstResponder) {
        
        [YBCustomBoard setCustomKeyboardViewWithClickedNumber:^(NSString *deadline) {
            
            _idTextFieldView.text  = [_idTextFieldView.text stringByAppendingString:deadline];
        } clickedDelete:^{
            
            if (_idTextFieldView.text.length > 0) {
                
                _idTextFieldView.text         = [_idTextFieldView.text substringToIndex:_idTextFieldView.text.length - 1];
            }
        }];
    }else{
        
        [YBCustomBoard removeCustomKeyBoardView];
    }
}

//实现通知处理
- (void)handleKeyboardDidHide:(NSNotification *)notification{
    
    [YBCustomBoard removeCustomKeyBoardView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
