//
//  ViewController.m
//  NYL录音转换mp3
//
//  Created by YinlongNie on 16/12/12.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//  利用64位lame库将录音准换成mp3




#import "ViewController.h"
#import "NYLLeavewordRecordView.h"

#import "CommonMethod.h"
#import "UIView+WLFrame.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<NYLLeavewordRecordViewDelegate>


@property (nonatomic, strong) UIButton *twoBtn;

@property (nonatomic, strong) NYLLeavewordRecordView *recodeView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

    _twoBtn = [CommonMethod createButtonWithButton:_twoBtn whoViewAdd:self.view title:@"点击录音" imageStr:@"" fontSize:17 frame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 40)];
    _twoBtn.backgroundColor = [UIColor redColor];
    [_twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}



#pragma mark - 开始录音 ======
- (void)twoBtnClick {
    // 而会传递之前的值来要求用户同意
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 用户同意获取数据
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                _recodeView2 = [[NYLLeavewordRecordView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) superVC:self];
                _recodeView2.delegate = self;
                [self.view addSubview:_recodeView2];
                
                
                // 开始录音
                [_recodeView2 recordBtnDidTouchUpInside];
                
                [self.twoBtn removeTarget:self action:@selector(actionSendVoiceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
                [self.twoBtn setTitle:@"点击发送" forState:(UIControlStateNormal)];
                // 点击发送
                [self.twoBtn addTarget:self action:@selector(actionSendVoiceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 可以显示一个提示框告诉用户这个app没有得到允许？
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"“就这看医生”想访问您的麦克风\n\n请启用麦克风-设置/隐私/麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    
}




// 点击发送按钮
- (void)actionSendVoiceBtnClick {
    [_recodeView2 actionSend];
}

// 取消录音代理
- (void)cancleRecordDelegate {
    
    //[_recodeView2 removeFromSuperview];
    NSLog(@"已经取消录音代理回调");
    
}



//  点击发送按钮会走该代理回调
//  发送录音代理
- (void)sendRecordUrlStr:(NSString *)voiceUrlStr timeLong:(NSString *)timeLong {
    
    
    NSString *msg = [NSString stringWithFormat:@"录音地址:%@\n\n录音时长:%@秒", voiceUrlStr, timeLong];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录音完成且换成mp3" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    
    // 请求网络提交语音文件
//    [self requestNetSendVoiceWithUrlStr:voiceUrlStr voiceLength:timeLong];
    // if 请求成功
    [self.twoBtn removeTarget:self action:@selector(actionSendVoiceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.twoBtn setTitle:@"点击录音" forState:UIControlStateNormal];
    [self.twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


/// 改变按钮状态的代理回调
- (void)changeBtn {
    
    [self.twoBtn removeTarget:self action:@selector(actionSendVoiceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    // 变成点录音
    [self.twoBtn setTitle:@"点击录音" forState:(UIControlStateNormal)];
    [self.twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

/// 改变按钮状态的代理回调
- (void)chageSend {
    
    [self.twoBtn removeTarget:self action:@selector(twoBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    // 变成点击发送
    [self.twoBtn setTitle:@"点击发送" forState:(UIControlStateNormal)];
    [self.twoBtn addTarget:self action:@selector(actionSendVoiceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
