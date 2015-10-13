//
//  CSRecorder.m
//  CloudSong
//
//  Created by youmingtaizi on 8/8/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "CSDefine.h"
#import "CSDataService.h"
#import "lame.h"

// TODO 临时用来记录录音的文件名，递增
#define AudioFileNameKey    @"AudioFileNameKey"

@interface CSRecorder () {
    AVAudioRecorder*    _recorder;
}
@end

@implementation CSRecorder

#pragma mark - Public Methods

+ (instancetype)sharedInstance {
    static CSRecorder* recorder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recorder = [[CSRecorder alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    });
    return recorder;
}

- (void)startRecord {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *index = [userDefaults objectForKey:AudioFileNameKey];
    if (!index)
        index = @0;
    else
        index = [NSNumber numberWithInt:[index intValue] + 1];
    [userDefaults setObject:index forKey:AudioFileNameKey];
    [userDefaults synchronize];
    
    NSString *fileName = [NSString stringWithFormat:@"%d", [index intValue]];
    NSString *fullFileName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:fullFileName] settings:nil error:nil];
    [_recorder prepareToRecord];
    [_recorder record];
}

- (void)stopRecord {
    [_recorder stop];
    [self transformCAFToMP3];
    [self uploadLastestFile];
}

- (void)uploadLastestFile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *index = [userDefaults objectForKey:AudioFileNameKey];
    NSString *fileName = [NSString stringWithFormat:@"%d", [index intValue]];
    NSString *fullFileName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    [[CSDataService sharedInstance] asyncUploadAudioFileWithURL:[NSURL fileURLWithPath:fullFileName] handler:^(BOOL success) {
        if (success) {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSError *error;
            [manager removeItemAtPath:fullFileName error:&error];
            if (error) {
                NSLog(@"Fail to remove audio file: %@", [error localizedDescription]);
            }
        }
        else
            [self uploadLastestFile];
    }];
    
}

#pragma mark - Private Methods

- (void)transformCAFToMP3 {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *index = [userDefaults objectForKey:AudioFileNameKey];
    
    NSString *fileName = [NSString stringWithFormat:@"%d", [index intValue]];
    NSString *fullFileName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    NSURL *mp3FilePath = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingFormat:@"%d.mp3", [index intValue]]];

    @try {
        int read, write;
        
        FILE *pcm = fopen([fullFileName cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (unsigned)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
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
    }
}

@end
