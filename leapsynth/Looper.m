//
//  Looper.m
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Looper.h"


@implementation Looper


static void handle_output_buffer(void *userdata, AudioQueueRef queue, AudioQueueBufferRef buffer)
{
    struct LooperCallbackState *state = (struct LooperCallbackState *)userdata;
    Looper *self = (__bridge Looper*)state->self;
    int num_samples = buffer->mAudioDataByteSize / sizeof(short);
    short *samples = buffer->mAudioData;
    
    if (self->isPlaying) {
        [self fillPlaybackBuffer:samples :num_samples];
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
}

- (id)init
{
    if (self) {
        loops = [[NSMutableArray alloc] init];
            
        callbackState.self = (__bridge void *)self;

        isRecording = NO;
        isPlaying = NO;
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)recordNewLoop
{
//    OSStatus status;


    Loop *loop = [[Loop alloc] init];
    [loops addObject:loop];
    isRecording = YES;

    
 }


- (void)stopRecording
{
    isRecording = NO;
}

- (void)playAll
{
    OSStatus status;

    Loop *loop = [loops lastObject];
    [loop start];

    isPlaying = YES;

    [self setupAudioFormat:&playbackFmt];
    status = AudioQueueNewOutput(&playbackFmt, handle_output_buffer, (void*)&callbackState, NULL, NULL, 0, &playbackQueue);
    for (int n=0; n < kNumBuffers; n++) {
        status = AudioQueueAllocateBuffer(playbackQueue, kBufferSize, &playbackBuffers[n]);
        playbackBuffers[n]->mAudioDataByteSize = kBufferSize;
        handle_output_buffer(&callbackState, playbackQueue, playbackBuffers[n]);
    }
    status = AudioQueueSetParameter (playbackQueue, kAudioQueueParam_Volume, 1.0);
    status = AudioQueueStart(playbackQueue, NULL);
}
- (void)stopPlayback
{
    isPlaying = NO;
    AudioQueueStop(playbackQueue, true);
    for (int n=0; n < kNumBuffers; n++) {
        AudioQueueFreeBuffer(playbackQueue, playbackBuffers[n]);
    }
    AudioQueueDispose(playbackQueue, true);
    playbackQueue = nil;
}
- (void)recordSamples:(short*)samples :(int)num_samples
{
    if (!isRecording)
        return;
    
    Loop *loop = [loops lastObject];
    [loop writeSamples:samples :num_samples];
//    NSDate *dataData = [NSData dataWithBytes:samples length:num_samples*sizeof(short)];
//    NSLog(@"RECD %@\n\n", dataData);

}


- (void)fillPlaybackBuffer:(short*)samples :(int)num_samples
{
    Loop *loop = [loops lastObject];
    [loop fillPlaybackBuffer:samples :num_samples];
//    memset(samples, 0, num_samples*sizeof(short));
    
//    NSDate *dataData = [NSData dataWithBytes:samples length:num_samples*sizeof(short)];
//    NSLog(@"PLAY %@\n\n", dataData);

}


- (void)setupAudioFormat:(AudioStreamBasicDescription*)fmt
{
    memset(fmt, 0, sizeof(AudioStreamBasicDescription));
    fmt->mSampleRate = kSampleRate;
    fmt->mFormatID = kAudioFormatLinearPCM;
    fmt->mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt->mFramesPerPacket = 1;
    fmt->mChannelsPerFrame = 1;
    fmt->mBitsPerChannel = 16;
    fmt->mBytesPerFrame = fmt->mBitsPerChannel/8;
    fmt->mBytesPerPacket = fmt->mBytesPerFrame*fmt->mFramesPerPacket;
}
@end
