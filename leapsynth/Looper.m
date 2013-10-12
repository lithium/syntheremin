//
//  Looper.m
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Looper.h"


@implementation Looper
@synthesize longestLoopSize;
@synthesize longestLoopIndex;
@synthesize delegate;

static void handle_output_buffer(void *userdata, AudioQueueRef queue, AudioQueueBufferRef buffer)
{
    struct LooperCallbackState *state = (struct LooperCallbackState *)userdata;
    Looper *self = (__bridge Looper*)state->self;
    int loopIndex = state->loopIndex;
    int num_samples = buffer->mAudioDataByteSize / sizeof(short);
    short *samples = buffer->mAudioData;
    
    if (self->isPlaying) {
        [self fillPlaybackBuffer:loopIndex :samples :num_samples];
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
}

- (id)init
{
    if (self) {
        loops = [[NSMutableArray alloc] init];
        
        memset(&audioFormat, 0, sizeof(AudioStreamBasicDescription));
        audioFormat.mSampleRate = kSampleRate;
        audioFormat.mFormatID = kAudioFormatLinearPCM;
        audioFormat.mFormatFlags =  kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        audioFormat.mFramesPerPacket = 1;
        audioFormat.mChannelsPerFrame = 1;
        audioFormat.mBitsPerChannel = 16;
        audioFormat.mBytesPerFrame = audioFormat.mBitsPerChannel/8;
        audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame*audioFormat.mFramesPerPacket;

        isRecording = NO;
        isPlaying = NO;
        
    }
    return self;
}

- (void)dealloc
{
}

- (BOOL)recordNewLoop
{
    if ([loops count] >= kMaxNumberOfLoops)
        return NO;

    Loop *loop = [[Loop alloc] init];
    [loops addObject:loop];
    isRecording = YES;
    
    if (delegateLoop) {
        [delegateLoop setDelegate:nil];
    }
    [loop setDelegate:delegate];
    delegateLoop = loop;

    return YES;
 }


- (void)stopRecording
{
    isRecording = NO;
    Loop *loop = [loops lastObject];
    if ([loop size] > longestLoopSize) {
        longestLoopSize = [loop size];
        longestLoopIndex = [loops count]-1;
        
        if (delegateLoop) {
            [delegateLoop setDelegate:nil];
        }
        [loop setDelegate:delegate];
        delegateLoop = loop;

    }
    
}

- (void)playAll
{
    isPlaying = YES;

    OSStatus status;

    for (int i=0; i < MIN([loops count], kMaxNumberOfLoops); i++) {
        states[i].self = (__bridge void*)self;
        states[i].loopIndex = i;
        
        if (i == longestLoopIndex) {
            Loop *loop = [loops objectAtIndex:i];
            [loop setDelegate:delegate];
        }

        status = AudioQueueNewOutput(&audioFormat, handle_output_buffer, (void*)&states[i], NULL, NULL, 0, &states[i].queue);
        for (int n=0; n < kNumBuffers; n++) {
            status = AudioQueueAllocateBuffer(states[i].queue, kBufferSize, &(states[i].buffers[n]));
            states[i].buffers[n]->mAudioDataByteSize = kBufferSize;
            handle_output_buffer(&states[i], states[i].queue, states[i].buffers[n]);
        }
        status = AudioQueueSetParameter (states[i].queue, kAudioQueueParam_Volume, 1.0);
    }
    for (int i=0; i < MIN([loops count], kMaxNumberOfLoops); i++) {
        status = AudioQueueStart(states[i].queue, NULL);
    }
}
- (void)stopPlayback
{
    isPlaying = NO;
    for (int i=0; i < [loops count]; i++) {
        AudioQueueStop(states[i].queue, true);
        for (int n=0; n < kNumBuffers; n++) {
            AudioQueueFreeBuffer(states[i].queue, states[i].buffers[n]);
        }
        AudioQueueDispose(states[i].queue, true);
    }
}
- (void)recordSamples:(short*)samples :(int)num_samples
{
    if (!isRecording)
        return;
    
    Loop *loop = [loops lastObject];
    [loop writeSamples:samples :num_samples];
}


- (void)fillPlaybackBuffer:(int)loopIndex :(short*)samples :(int)num_samples
{
    Loop *loop = [loops objectAtIndex:loopIndex];
    [loop fillPlaybackBuffer:samples :num_samples];
}


@end
