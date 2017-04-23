//
//  QBXKeyBoardCustomView.h
//  Qianbuxian_iPhone
//
//  Created by 高艳彬 on 16/8/31.
//  Copyright © 2016年 JanChenyo. All rights reserved.
//

#import <UIKit/UIKit.h>


// 注意只有以下两种数字键盘才有效果：UIKeyboardTypeNumberPad，UIKeyboardTypePhonePad；

typedef void(^clickNumber)(NSString *deadline);

typedef void(^clickDelete)();

@protocol QBXKeyBoardCustomViewDelegate <NSObject>

- (void)addNumbersWithMessage:(NSString *)message;
- (void)deleteFunction:(NSString *)message;
@end


@interface YBCustomBoard : UIView

@property (nonatomic, weak) id<QBXKeyBoardCustomViewDelegate> delegate;

+ (instancetype)sharedCustomKeyBoardView;

// 删除自定义键盘
+ (void)removeCustomKeyBoardView;



/**
 设置自定义的身份证键盘

 @param clickNumber 点击按钮添加信息
 @param clickDelete 删除功能
 */
+ (void)setCustomKeyboardViewWithClickedNumber:(clickNumber )clickNumber clickedDelete:(clickDelete )clickDelete;

+ (void)setCustomKeyboardviewwithDelegate:(id <QBXKeyBoardCustomViewDelegate>)delegate;

- (void)setCustomKeyboardViewWithClickedNumber:(clickNumber )clickNumber clickedDelete:(clickDelete )clickDelete;

- (void)setCustomKeyboardviewwithDelegate:(id <QBXKeyBoardCustomViewDelegate>)delegate;

@end
