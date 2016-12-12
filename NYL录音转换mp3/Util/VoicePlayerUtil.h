//
//  VoicePlayerUtil.h
//  Expert
//
//  Created by YinlongNie on 16/5/26.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//  播放工具

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol VoicePlayerUtilDelegate <NSObject>

@optional
- (void)stopImageViewAnimation;

@end

@interface VoicePlayerUtil : NSObject


+ (instancetype)shareVoicePlayerInstance;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, assign) id<VoicePlayerUtilDelegate>delegate;

- (void)playRecordFile:(NSURL *)url;

- (void)stopPlaying;

@end
