//
//  Looper.m
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Looper.h"


@implementation Looper


static void handle_input_buffer(void *userdata, AudioQueueRef queue, AudioQueueBufferRef buffer, const AudioTimeStamp *start_time, UInt32 num_packets, const AudioStreamPacketDescription *packet_description)
{
    struct LooperCallbackState *state = (struct LooperCallbackState *)userdata;
    Looper *self = (__bridge Looper*)state->self;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;

    Loop *loop = [self->loops lastObject];
    [loop writeSamples:samples :num_samples];

    if (self->isRecording) {
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
}

static void handle_output_buffer(void *userdata, AudioQueueRef queue, AudioQueueBufferRef buffer)
{
    struct LooperCallbackState *state = (struct LooperCallbackState *)userdata;
    Looper *self = (__bridge Looper*)state->self;
    int num_samples = buffer->mAudioDataByteSize / 2;
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
     
        audioFormat.mFormatID = kAudioFormatLinearPCM;
        audioFormat.mSampleRate = kSampleRate;
        audioFormat.mFramesPerPacket = 1;
        audioFormat.mChannelsPerFrame = 1;
        audioFormat.mBitsPerChannel = 16;
        audioFormat.mBytesPerFrame = audioFormat.mBitsPerChannel/8;
        audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame*audioFormat.mFramesPerPacket;
        audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        
        callbackState.self = (__bridge void *)self;
        
        AudioQueueNewInput(&audioFormat, handle_input_buffer, (void *)&callbackState, NULL, kCFRunLoopCommonModes, 0, &recordingQueue); 
        isRecording = NO;
    }
    return self;
}

- (void)dealloc
{
    AudioQueueDispose(recordingQueue, true);
}

- (void)recordNewLoop
{
    Loop *loop = [[Loop alloc] init];
    [loops addObject:loop];
    isRecording = YES;
    AudioQueueStart(recordingQueue, NULL);
}

- (void)stopRecording
{
    isRecording = NO;
    AudioQueueStop(recordingQueue, true);
}

- (void)playAll
{
    isPlaying = YES;

    OSStatus status;
    
    status = AudioQueueNewOutput(&audioFormat, handle_output_buffer, (void*)&callbackState, NULL, NULL, 0, &playbackQueue);
    for (int n=0; n < kNumBuffers; n++) {
        status = AudioQueueAllocateBuffer(playbackQueue, kBufferSize, &playbackBuffers[n]);
        playbackBuffers[n]->mAudioDataByteSize = kBufferSize;
        //prime
        handle_output_buffer(&callbackState, playbackQueue, playbackBuffers[n]);
    }

}
- (void)stopPlayback
{
    isPlaying = NO;
}


- (void)fillPlaybackBuffer:(short*)samples :(int)num_samples
{
    Loop *loop = [loops lastObject];
    [loop fillPlaybackBuffer:samples :num_samples];
}
@end
