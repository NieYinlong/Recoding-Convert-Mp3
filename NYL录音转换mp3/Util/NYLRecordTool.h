//
//  NYLRecordTool.h
//  Expert
//
//  Created by YinlongNie on 16/6/20.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//  录音工具

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class NYLRecordTool;

@protocol NYLRecordToolDelegate <NSObject>

@optional

- (void)recordTool:(NYLRecordTool *)recordTool didstartRecoring:(int)no;
// 完成播放代理
- (void)avaudioPlayFinishdePlay;

- (void)sendMp3Url:(NSURL *)url;

- (void)sendMp3Path:(NSString *)mp3Path;

@end



@interface NYLRecordTool : NSObject

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;



/** 开始录音 */
- (void)startRecording;//WithFileName:(NSString *)fileName;


/*  继续录音 */
- (void)continueRecordAtTime:(NSTimeInterval)time;



/** 停止录音 */
- (void)stopRecording;

/* 暂停录音 */
- (void)pauseRecording;


- (void)tryListenVoice;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 更新图片的代理 */
@property (nonatomic, assign) id<NYLRecordToolDelegate> delegate;
/** 播放器对象 */
//@property (nonatomic, strong) AVAudioPlayer *player;

@end
