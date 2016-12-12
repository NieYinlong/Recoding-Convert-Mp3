//
//  NYLLeavewordRecordView.h
//  Expert
//
//  Created by YinlongNie on 16/9/11.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//
//  这个View   不带暂停的

#import <UIKit/UIKit.h>
@protocol NYLLeavewordRecordViewDelegate <NSObject>

- (void)sendRecordUrlStr:(NSString *)voiceUrlStr timeLong:(NSString *)timeLong;
// 取消录音代理
- (void)cancleRecordDelegate;
// 变为点击录音按钮
-(void)changeBtn;
// 变为点击发送按钮
- (void)chageSend;

@end



@interface NYLLeavewordRecordView : UIView


@property (nonatomic, strong) UIView *bgView;
- (instancetype)initWithFrame:(CGRect)frame superVC:(UIViewController *)superVC;


@property (nonatomic, assign) id<NYLLeavewordRecordViewDelegate>delegate;

@property (nonatomic, strong) UIButton *recordBtn;

// 加号按钮
@property (nonatomic, strong) UIButton *addBtn;


@property (nonatomic, strong) UIViewController *superVC;

// 录音时长计时器
@property (nonatomic, strong) NSTimer *timer;


/***********************************************************************************/
/***********************************************************************************/
/** 试听按钮 */
@property (nonatomic, strong) UIButton *tryListenBtn;

/**
 *  暂停 或者 继续录音按钮
 */
@property (nonatomic, strong) UIButton *pauseOrContinueRecordBtn;


// 取消录音
@property (nonatomic, strong) UIButton *cancleRecordBtn;

// 试听中状态
@property (nonatomic ,assign) BOOL isSound;



// 共外界调用录音
- (void)recordBtnDidTouchUpInside;

// 外界调用 发送
-(void)actionSend;

/***********************************************************************************/
/***********************************************************************************/

@end
