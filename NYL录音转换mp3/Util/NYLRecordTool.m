//
//  NYLRecordTool.m
//  Expert
//
//  Created by YinlongNie on 16/6/20.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//

#import "NYLRecordTool.h"
#import "lame.h"
#define getCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

@interface NYLRecordTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *fileName;

// 已经转换的的mp3
@property (nonatomic, strong) NSString *havedToMp3Path;


@end


@implementation NYLRecordTool

static NYLRecordTool *instance;
#pragma mark - 单例
+ (instancetype)sharedRecordTool {
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



- (void)startRecording/*WithFileName:(NSString *)fileName*/ {
    // 录音时停止播放 删除曾经生成的文件
    //[self stopPlaying];
    //[self destructionRecordingFile];
    
    
    // 真机环境下需要的代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil){
        
        
    }
    else{
        
        [session setActive:YES error:nil];
    }
    
    // 1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"luyin.caf"];
    
    self.havedToMp3Path = filePath;//[NSURL URLWithString:filePath];
    
    
    //录音设置
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.havedToMp3Path] settings:settings error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [self.recorder record];
    
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    //self.timer = timer;
}


- (void)continueRecordAtTime:(NSTimeInterval)time {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    
    
    [_recorder record];
    [_timer fire];
}


- (void)stopRecording {
    [self.recorder stop];
    [self.timer invalidate];
}


// 暂停
- (void)pauseRecording {
    [self.recorder pause];
    [_timer invalidate];
}

// 试听
- (void)tryListenVoice {
    
   // [[VoicePlayerUtil shareVoicePlayerInstance] playRecordFile:[NSURL URLWithString:self.havedToMp3Path]];
}

- (void)updateImage {
    if (self.recorder != nil) {
        NSLog(@"变换样式%@",[NSDate date]);
        [self.recorder updateMeters];
        double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
        float result  = 10 * (float)lowPassResults;
        int no = 1;
        if (result >= 0 && result <= 1.3) {
            no = 1;
        } else if (result > 1.3 && result <= 2) {
            no = 1;
        } else if (result > 2 && result <= 3.0) {
            no = 2;
        } else if (result > 3.0 && result <= 3.0) {
            no = 3;
        } else if (result > 5.0 && result <= 10) {
            no = 4;
        } else if (result > 10 && result <= 40) {
            no = 4;
        } else if (result > 40) {
            no = 4;
        }
        
        if ([self.delegate respondsToSelector:@selector(recordTool:didstartRecoring:)]) {
            [self.delegate recordTool:self didstartRecoring: no];
        }
    }
  
}
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        // NSLog(@"录音成功");
        [_timer invalidate];
        _timer = nil;
        [self audio_PCMtoMP3];
    }
}


- (void)audio_PCMtoMP3
{
    
    NSString *cafFilePath = nil;
    NSString *mp3FilePath = nil;
    
    cafFilePath = self.havedToMp3Path;
    
        
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
        // 拼接要写入文件的路径
        //mp3FilePath = [documentsPath stringByAppendingPathComponent:@"MP3advice.mp3"];
    
    // 这里随机路径
    NSString *pinJieStr = getCurentTime;
    pinJieStr = [NSString stringWithFormat:@"%d%@.mp3",arc4random()%10000, pinJieStr];
    mp3FilePath = [documentsPath stringByAppendingPathComponent:pinJieStr];
        
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        
            // 记录新的MP3地址
        self.havedToMp3Path = mp3FilePath;
       
        if (_delegate && [_delegate respondsToSelector:@selector(sendMp3Url:)]) {
            [_delegate sendMp3Url:[NSURL URLWithString:self.havedToMp3Path]];
        }

        
        if (_delegate && [_delegate respondsToSelector:@selector(sendMp3Path:)]) {
            [_delegate sendMp3Path:self.havedToMp3Path];
        }
       
    }
}

@end
