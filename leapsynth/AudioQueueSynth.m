//
//  AudioQueueSynth.m
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AudioQueueSynth.h"
@implementation AudioQueueSynth

@synthesize looper;


static void audioqueue_osc_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    struct CallbackArg *args = (struct CallbackArg *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    AudioQueueSynth *self = (__bridge AudioQueueSynth *)args->self;
    
    //fill with silence
    for (int i=0; i < num_samples; i++) {
        samples[i] = 0;
    }
    
    //get the output from the mixers
    [self getSamples:samples :num_samples];
    
    //send to recorder
    [self->looper recordSamples:samples :num_samples];

    
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}


- (id) init
{
    if (self) {
        self = [super init];
        
        AudioStreamBasicDescription fmt = {0};
        fmt.mSampleRate = kSampleRate;
        fmt.mFormatID = kAudioFormatLinearPCM;
        fmt.mFormatFlags =  kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        fmt.mFramesPerPacket = 1;
        fmt.mChannelsPerFrame = 1;
        fmt.mBitsPerChannel = 16;
        fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
        fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
        OSStatus status;

        callbackArgs.self = (__bridge void*)self;
        status = AudioQueueNewOutput(&fmt, audioqueue_osc_callback, (void*)&callbackArgs, NULL, NULL, 0, &queueOsc);
        for (int n=0; n < kNumBuffers; n++) {
            status = AudioQueueAllocateBuffer(queueOsc, kBufferSize, &buffersOsc[n]);
            buffersOsc[n]->mAudioDataByteSize = kBufferSize;
            audioqueue_osc_callback((void*)&callbackArgs, queueOsc, buffersOsc[n]);
        }
        status = AudioQueueSetParameter(queueOsc, kAudioQueueParam_Volume, 1.0);

        looper = [[Looper alloc] init];
        

    }
     
    return self;
}

- (void)start
{
    AudioQueueStart(queueOsc, NULL);
}
- (void)stop
{    
    AudioQueueStop(queueOsc, true);
}


- (void)noteOn
{        
    for (int i=0; i < kNumOscillators; i++) {
        AudioQueueFlush(queueOsc);
    }
    [super noteOn];
}


@end
