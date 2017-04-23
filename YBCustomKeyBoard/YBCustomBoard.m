//
//  QBXKeyBoardCustomView.m
//  Qianbuxian_iPhone
//
//  Created by 高艳彬 on 16/8/31.
//  Copyright © 2016年 JanChenyo. All rights reserved.
//

#import "YBCustomBoard.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YBCustomBoard()

@property (nonatomic ,copy) clickNumber    clickNumber;
@property (nonatomic ,copy) clickDelete    clickDelete;

@end


@implementation YBCustomBoard

// 单利模式
+(instancetype)sharedCustomKeyBoardView{
    
    static YBCustomBoard *customKeyBoard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        customKeyBoard = [[YBCustomBoard alloc] init];
        
    });
    
    return customKeyBoard;
}
// 初始化
    // block
+ (void)setCustomKeyboardViewWithClickedNumber:(clickNumber )clickNumber clickedDelete:(clickDelete )clickDelete{
    
    NSLog(@"🍀🍀🍀🍀🍀🍀🍀🍀\n 1111");
    YBCustomBoard *customKeyBoard = [YBCustomBoard sharedCustomKeyBoardView];
    [customKeyBoard setCustomKeyboardViewWithClickedNumber:clickNumber clickedDelete:clickDelete];
    
}
    // delegate
+ (void)setCustomKeyboardviewwithDelegate:(id <QBXKeyBoardCustomViewDelegate>)delegate{

    NSLog(@"🍀🍀🍀🍀🍀🍀🍀🍀\n 1111");
    YBCustomBoard *customKeyBoard = [YBCustomBoard sharedCustomKeyBoardView];
    [customKeyBoard setCustomKeyboardviewwithDelegate:delegate];
}

- (void)setCustomKeyboardViewWithClickedNumber:(clickNumber )clickNumber clickedDelete:(clickDelete)clickDelete{
    
    [self keyboardChange];
    YBCustomBoard *board = [YBCustomBoard sharedCustomKeyBoardView];
    
    board.clickNumber = clickNumber;
    board.clickDelete = clickDelete;
    
}

- (void)setCustomKeyboardviewwithDelegate:(id <QBXKeyBoardCustomViewDelegate>)delegate{

    NSLog(@"🍀🍀🍀🍀🍀🍀🍀🍀\n 2222");
    
    YBCustomBoard *board = [YBCustomBoard sharedCustomKeyBoardView];
    board.delegate = delegate;
    [self keyboardChange];
    
}


- (void)keyboardChange{
    
    // 找到展示的键盘界面
    UIView *keyboard = [self findKeyboard];
    YBCustomBoard *boardView = [YBCustomBoard sharedCustomKeyBoardView];
    boardView.frame = CGRectMake(0, 0, keyboard.frame.size.width, keyboard.frame.size.height);
    boardView.backgroundColor = [YBCustomBoard colorFromHexRGB:@"CCCCCC"];
    [keyboard  addSubview:boardView];
    
    
    
    CGFloat width  = (keyboard.frame.size.width )/3;
    CGFloat height = (keyboard.frame.size.height)/4;
    
    for (int i = 0 ; i < 12; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 + i%3 * (width + 0.5), 0 + i/3 * (height + 0.5), width, height)];
        
        [button setTitleColor:[YBCustomBoard colorFromHexRGB:@"333333"] forState:UIControlStateNormal];
    
        button.layer.borderWidth = 0.25/2;
        button.layer.borderColor = [YBCustomBoard colorFromHexRGB:@"CCCCCC"].CGColor;
        if (i == 9) {
            
            [button setTitle:@"X" forState:UIControlStateNormal];
        }else if (i == 10){
            
            [button setTitle:@"0" forState:UIControlStateNormal];
        }else if (i == 11){
//            [button setTitle:@"删除" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"iconfont-shanchu-2"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"iconfont-shanchu-4"] forState:UIControlStateHighlighted];
        }else{
        
            [button setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        }
        
        if (i == 11) {
            
//            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button setBackgroundImage:[YBCustomBoard imageWithColor:[YBCustomBoard colorFromHexRGB:@"D2D5DC"] size:button.frame.size] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[YBCustomBoard imageWithColor:[YBCustomBoard colorFromHexRGB:@"C2C4CB"] size:button.frame.size] forState:UIControlStateHighlighted];
            [button addTarget:boardView action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
            button.titleLabel.font = [UIFont systemFontOfSize:30];
            [button setBackgroundImage:[YBCustomBoard imageWithColor:[YBCustomBoard colorFromHexRGB:@"FFFFFF"] size:button.frame.size] forState:UIControlStateNormal];
            [button setBackgroundImage:[YBCustomBoard imageWithColor:[YBCustomBoard colorFromHexRGB:@"EBEBEB"] size:button.frame.size] forState:UIControlStateHighlighted];
            [button addTarget:boardView action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
        [boardView addSubview:button];
    }
}

#pragma mark --- Event
- (void)click:(UIButton *)sender{
    
    // dididid   1057  1103
    // 系统键盘默认音   1104
    SystemSoundID soundID = 1104;
    
    AudioServicesPlaySystemSound(soundID);
    
    YBCustomBoard *board = [YBCustomBoard sharedCustomKeyBoardView];
    
    // 优先 block方法
    if (board.clickNumber) {
        
        board.clickNumber(sender.titleLabel.text);
        return;
    }
    if (board.delegate) {
        
        [board addNumbersWithMessage:sender.titleLabel.text];
        return;
    }
}

- (void)delete:(UIButton *)sender{
    
    AudioServicesPlaySystemSound(1104);
    YBCustomBoard *board = [YBCustomBoard sharedCustomKeyBoardView];
    
    if (board.clickDelete) {
        
        board.clickDelete();
        return;
    }
    if (board.delegate) {
        
        [board deleteFunction:sender.titleLabel.text];
        return;
    }
    
}

- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *sudView in [view subviews])
    {
        
        if (strstr(object_getClassName(sudView), "UIKeyboard")) {
            return sudView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:sudView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    
    return nil;
}

+ (void)removeCustomKeyBoardView{

    YBCustomBoard *keyBoardView = [YBCustomBoard sharedCustomKeyBoardView];
    keyBoardView.delegate = nil;
    
    for (UIView *object in keyBoardView.subviews) {
        
        [object removeFromSuperview];
    }
    [keyBoardView removeFromSuperview];
}

#pragma mark --- Delegate
- (void)addNumbersWithMessage:(NSString *)message{

    YBCustomBoard *customKeyBoard = [YBCustomBoard sharedCustomKeyBoardView];
    
    if (customKeyBoard.delegate && [customKeyBoard.delegate respondsToSelector:@selector(addNumbersWithMessage:)]) {
    
        [customKeyBoard.delegate addNumbersWithMessage:message];
    }
}

- (void)deleteFunction:(NSString *)message{

    YBCustomBoard *customKeyBoard = [YBCustomBoard sharedCustomKeyBoardView];
    
    if (customKeyBoard.delegate && [customKeyBoard.delegate respondsToSelector:@selector(deleteFunction:)]) {
        
        [customKeyBoard.delegate deleteFunction:message];
    }

}

//十六进制色值转换
+ (nullable UIColor *) colorFromHexRGB:(nullable NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode);
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

//色值转图片
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
