//
//  NYLLeavewordRecordView.m
//  Expert
//
//  Created by YinlongNie on 16/9/11.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//

#import "NYLLeavewordRecordView.h"
#import "VoicePlayerUtil.h"
#import "NYLRecordTool.h"
#import "UIView+WLFrame.h"
#import "CommonMethod.h"
#define kWindow [[[UIApplication sharedApplication] delegate] window]

@interface NYLLeavewordRecordView ()<NYLRecordToolDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *showTimeMicroView;

@property (nonatomic, strong) UIImageView *microImageView;
@property (nonatomic, strong) UILabel *alertLB;
// 当前录音的时长
@property (nonatomic, strong) UILabel *currentTimeLB;
// 总的时长(固定)
@property (nonatomic, strong) UILabel *totalTimeLB;




@property (nonatomic, assign) BOOL isSend;


// 试听计时展示label
@property (nonatomic, strong) UILabel *tryListenTimeLB;
// 试听计时器
@property (nonatomic, strong) NSTimer *tryListenTimer;
// 试听时长
@property (nonatomic, assign) int tryListenTimeLong;


//@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int timeLong;

@property (nonatomic, strong) NSURL *mp3Url;


@property (nonatomic, assign) BOOL isSave;

@end

@implementation NYLLeavewordRecordView

- (instancetype)initWithFrame:(CGRect)frame superVC:(UIViewController *)superVC{
    if (self = [super initWithFrame:frame]) {
        [self addsubView:frame];
        self.superVC = superVC;
        [NYLRecordTool sharedRecordTool].delegate = self;
    }
    return self;
}


- (void)addsubView:(CGRect)frame {
    
    _timeLong = 0;
    //    CGFloat height = frame.size.height;
    //    CGFloat width = frame.size.width;
    
    self.backgroundColor = [UIColor whiteColor];
    
}



#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    
    //self.startTimeStr = getCurentTime;
    
}

// 点击 开始录音
- (void)recordBtnDidTouchUpInside{

    

    [[NYLRecordTool sharedRecordTool] startRecording];
    [NYLRecordTool sharedRecordTool] .delegate = self;
    [self createShowView];
    _isSend = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:@"" repeats:YES];
    
   
}

- (void)timer:(NSTimer *)timer {
    
    _count++;
    _timeLong++;
    NSLog(@"_timeLong =========>%d  count----->%d", _timeLong, _count);
    _currentTimeLB.text = [NSString stringWithFormat:@"%.2d : %.2d", (int)_count/60, (int)_count % 60];
    
    
    if (_count==300) {
        [_timer invalidate];
        [_tryListenTimer invalidate];
        // 先暂停
        [[NYLRecordTool sharedRecordTool] pauseRecording];
        _isSave = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"录音时长不能超过5分钟,是否送生当前录音" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        _count = 0;
        _timeLong=300;
    }
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 199) {
        [_superVC.navigationController popViewControllerAnimated:YES];
        
    } else {
        if (buttonIndex == 0) {
            
            
            
            NSLog(@"发送录音: %@", self.mp3Url);
            [self changeBtn];
            [_bgView removeFromSuperview];
            
            _isSave = YES;
            
            // 只要停止 就会走代理方法
            [[NYLRecordTool sharedRecordTool] stopRecording];
            
            
            
        } else {
            NSLog(@"取消发送");
            [_bgView removeFromSuperview];
            _isSave = NO;
            [self changeBtn];
            
            
        }
    }
    
    
}




#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}




#pragma mark - 创建弹框的录音视图

- (void)createShowView {
    
    _timeLong =0;
    _tryListenTimeLong = 0;
    _count = 0;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
    [kWindow addSubview:_bgView];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    //_bgView.alpha = 0.8;
    _showTimeMicroView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, (kScreenHeight-200)/2-60, 200, 200)];
    //_showTimeMicroView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-(kScreenWidth-40))/2, (kScreenHeight-(kScreenWidth-40-50))/2-60, kScreenWidth-40, kScreenWidth-40-50)];
    _showTimeMicroView.backgroundColor = [UIColor blackColor];
    _showTimeMicroView.alpha = 0.8;
    _showTimeMicroView.layer.cornerRadius = 18;
    [_bgView addSubview:_showTimeMicroView];
    
    
    
    
    _alertLB = [CommonMethod createLabel:_alertLB whoViewAdd:_bgView text:@""/*@"正在录音"*/ fontSize:18 frame:CGRectMake((kScreenWidth-200)/2, _showTimeMicroView.top+15, 200, 20)];
    _alertLB.textAlignment = NSTextAlignmentCenter;
    _alertLB.textColor = [UIColor whiteColor];
    
    
    _microImageView = [CommonMethod createImageView:_microImageView whoViewAdd:_bgView frame:CGRectMake((kScreenWidth-53.5)/2, _showTimeMicroView.top+40, 50+3.5, 50) imageName:@"音量1"];
    
    _currentTimeLB = [CommonMethod createLabel:_currentTimeLB whoViewAdd:_bgView text:@"00:00" fontSize:14 frame:CGRectMake(_showTimeMicroView.left+10, _microImageView.bottom+10, 80, 20)];
    _currentTimeLB.textAlignment = NSTextAlignmentRight;
    _currentTimeLB.textColor = [CommonMethod getColor:@"ff6600"];
    
    _totalTimeLB = [CommonMethod createLabel:_totalTimeLB whoViewAdd:_bgView text:@"05:00" fontSize:14 frame:CGRectMake(_showTimeMicroView.right-80-10, _microImageView.bottom+10, 80, 20)];
    _totalTimeLB.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    // ----- 试听 --------
    _tryListenBtn = [CommonMethod createButtonWithButton:_tryListenBtn whoViewAdd:_bgView title:@"" imageStr:@"playBtnImage" fontSize:14 frame:CGRectMake((kScreenWidth-45)/2, _showTimeMicroView.top+40, 45, 43)];
    [_tryListenBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_tryListenBtn addTarget:self action:@selector(tryListenBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    //_tryListenBtn.backgroundColor = kMainColor;
    _isSound = NO;
    _tryListenBtn.hidden = YES;
    
    
    
    
    // -------- 试听展示label ---------
    _tryListenTimeLB = [CommonMethod createLabel:_tryListenTimeLB whoViewAdd:_bgView text:@"00:00" fontSize:14 frame:CGRectMake((kScreenWidth-80)/2, _tryListenBtn.bottom+10, 80, 20)];
    _tryListenTimeLB.textColor = [CommonMethod getColor:@"ff6600"];
    _tryListenTimeLB.textAlignment = NSTextAlignmentCenter;
    _tryListenTimeLB.hidden = YES;
    
    
    // ------- 暂停OR继续 --------
    _pauseOrContinueRecordBtn = [CommonMethod createButtonWithButton:_pauseOrContinueRecordBtn whoViewAdd:_bgView title:@"暂 停" imageStr:@"" fontSize:18 frame:CGRectMake(_showTimeMicroView.left+20, _showTimeMicroView.bottom-30-10, 50, 30)];
    [_pauseOrContinueRecordBtn addTarget:self action:@selector(pauseOrContinueRecordBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    //_pauseOrContinueRecordBtn.backgroundColor = kMainColor;
    
    // ---------- 取消 ---------
    _cancleRecordBtn = [CommonMethod createButtonWithButton:_cancleRecordBtn whoViewAdd:_bgView title:@"取 消" imageStr:@"" fontSize:18 frame:CGRectMake(_showTimeMicroView.right-50-20, _showTimeMicroView.bottom-30-10, 50, 30)];
    //[UIButton addButtonBorder:kMainColor boderWidth:1 btn:_cancleRecordBtn];
    [_cancleRecordBtn addTarget:self action:@selector(actionCancleRecordBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 如果录音时长大于0
    [self chageSend];
}

- (void)changeBtn {
    
    _isSave = NO;
    _count = 0;
    if (self.delegate && [_delegate respondsToSelector:@selector(changeBtn)]) {
        [_delegate changeBtn];
    }
    
}


- (void)chageSend {
    _isSave = YES;
    if (self.delegate && [_delegate respondsToSelector:@selector(chageSend)]) {
        [_delegate chageSend];
    }
    
    _count = 0;
}



#pragma mark - 取消回复
- (void)actionCancleRecordBtnClick {
    NSLog(@"取消回复");
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancleRecordDelegate)]) {
        // 取消录音代理
        [_delegate cancleRecordDelegate];
    }
    
    
    _count = 0;
    [_timer invalidate];
    [_tryListenTimer invalidate];
    
    
    [_bgView removeFromSuperview];
    [NYLRecordTool sharedRecordTool].recorder = nil;
    [[VoicePlayerUtil shareVoicePlayerInstance] stopPlaying];
    
    [self changeBtn];
    
}






#pragma mark - 点击发送
- (void)actionSend {
    
    _count = 0;
    [_timer invalidate];
    [_bgView removeFromSuperview];
    
    [self changeBtn];
    if (_timeLong < 1) {
        [CommonMethod showAlterMessage:@"录音时长不能小于1秒"];
        return;
    }
    [[NYLRecordTool sharedRecordTool] stopRecording];
    [[VoicePlayerUtil shareVoicePlayerInstance] stopPlaying];
    _isSave = YES;
    
}



#pragma mark - NYLRecordToolDelegate
- (void)sendMp3Path:(NSString *)mp3Path {
    
    
    
    self.mp3Url = [NSURL fileURLWithPath:mp3Path];
    [NYLRecordTool sharedRecordTool].recorder = nil;
    
    if (_isSave == YES) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendRecordUrlStr:timeLong:)]) {
            
            [_delegate sendRecordUrlStr:mp3Path timeLong:[NSString stringWithFormat:@"%d", _timeLong]];
        }
    }
    
    
}
- (void)recordTool:(NYLRecordTool *)recordTool didstartRecoring:(int)no {
    NSString *imageName = [NSString stringWithFormat:@"音量%d", no];
    self.microImageView.image = [UIImage imageNamed:imageName];
    
}






#pragma mark - 试听
- (void)tryListenBtnClick {
    
    if (_isSound == NO) {
        //试听播放中
        [_tryListenBtn setBackgroundImage:[UIImage imageNamed:@"YJH播放"] forState:(UIControlStateNormal)];
        [[NYLRecordTool sharedRecordTool] tryListenVoice];
        [self initTryListenTimer];
    }else{
        //试听停止
        [_tryListenBtn setBackgroundImage:[UIImage imageNamed:@"playBtnImage"] forState:(UIControlStateNormal)];
        [[NYLRecordTool sharedRecordTool] pauseRecording];
        [self deleteTryListenTimer];
        [_timer invalidate];
        _timer = nil;
        _tryListenTimeLB.text = [NSString stringWithFormat:@"%.2d : %.2d", (int)_timeLong/60, (int)_timeLong % 60];
    }
    _isSound = !_isSound;
}


- (void)pauseOrContinueRecordBtnClick:(UIButton *)btn{
    
    if (btn.selected == NO) {
        // 暂停录音
        [[NYLRecordTool sharedRecordTool] pauseRecording];
        [self hiddenCurrentTimeLBAndTotalTimeLBAndMicroImageViewIsHidden:YES];
        [_timer invalidate];
        _timer = nil;
        _tryListenTimeLB.text = [NSString stringWithFormat:@"%.2d : %.2d", (int)_timeLong/60, (int)_timeLong % 60];
        
        [btn setTitle:@"继续" forState:(UIControlStateNormal)];
        [_tryListenBtn setBackgroundImage:[UIImage imageNamed:@"playBtnImage"] forState:(UIControlStateNormal)];
    } else {
        // 继续录音
        _isSound = NO;
        [[NYLRecordTool sharedRecordTool] continueRecordAtTime:0];
        [self hiddenCurrentTimeLBAndTotalTimeLBAndMicroImageViewIsHidden:NO];
        [btn setTitle:@"暂停" forState:(UIControlStateNormal)];
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:@"" repeats:YES];
        
        [[VoicePlayerUtil shareVoicePlayerInstance] stopPlaying];
        [self deleteTryListenTimer];
    }
    
    _pauseOrContinueRecordBtn.selected = !_pauseOrContinueRecordBtn.selected;
}

// 创建试听计时器
- (void)initTryListenTimer {
    _tryListenTimeLong = _timeLong;
    
    [self deleteTryListenTimer];
    _tryListenTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tryListenTimer:) userInfo:@"" repeats:YES];
}

- (void)deleteTryListenTimer {
    [_tryListenTimer invalidate];
    _tryListenTimer = nil;
}


- (void)tryListenTimer:(NSTimer *)timer {
    _tryListenTimeLong--;
    _tryListenTimeLB.text = [NSString stringWithFormat:@"%.2d : %.2d", (int)_tryListenTimeLong/60, (int)_tryListenTimeLong % 60];
    if (_tryListenTimeLong==0) {
        [self deleteTryListenTimer];
    }
}



#pragma mark - 隐藏 OR 显示
- (void)hiddenCurrentTimeLBAndTotalTimeLBAndMicroImageViewIsHidden:(BOOL)isHidden {
    _currentTimeLB.hidden = isHidden;
    _totalTimeLB.hidden = isHidden;
    self.microImageView.hidden = isHidden;
    
    _tryListenBtn.hidden = !isHidden;
    _tryListenTimeLB.hidden = !isHidden;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [_tryListenTimer invalidate];
    _tryListenTimer = nil;
}

@end
