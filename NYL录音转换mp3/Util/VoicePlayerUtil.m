//
//  VoicePlayerUtil.m
//  Expert
//
//  Created by YinlongNie on 16/5/26.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//

#import "VoicePlayerUtil.h"

@interface VoicePlayerUtil ()<AVAudioPlayerDelegate>


@end
@implementation VoicePlayerUtil

static VoicePlayerUtil *instance;
#pragma mark - 单例
+ (instancetype)shareVoicePlayerInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

- (void)playRecordFile:(NSURL *)url {
    if (url != nil) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.player.delegate = self;
            self.player.volume = 1.0;
            [self.player play];
        });
    }
}

- (void)stopPlaying {
    [self.player stop];
    //[[VoicePlayerUtil shareVoicePlayerInstance] playRecordFile:nil];
    
}


#pragma mark - AVAudioPlayerDelegate 播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_delegate && [_delegate respondsToSelector:@selector(stopImageViewAnimation)]) {
        [_delegate stopImageViewAnimation];
    }
}





@end
