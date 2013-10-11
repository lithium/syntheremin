//
//  AudioQueueSynth.m
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AudioQueueSynth.h"
@implementation AudioQueueSynth

static void audioqueue_osc1_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    AudioQueueSynth *synth = (__bridge AudioQueueSynth *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    [synth->osc1 getSamples:samples :num_samples];
    if (synth->vcfEnabled) {
        [synth->vcf modifySamples:samples :num_samples];
    }
    if (synth->vcaEnabled) {
        [synth->vca modifySamples:samples :num_samples];
    }
    
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}

static void audioqueue_osc2_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    AudioQueueSynth *synth = (__bridge AudioQueueSynth *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    [synth->osc2 getSamples:samples :num_samples];
    if (synth->vcfEnabled) {
        [synth->vcf2 modifySamples:samples :num_samples];
    }
    if (synth->vcaEnabled) {
        [synth->vca modifySamples:samples :num_samples];
    }
    
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}

- (id) init
{
    if (self) {
        self = [super init];
        
        AudioStreamBasicDescription fmt = {0};
        fmt.mSampleRate = kSampleRate;
        fmt.mFormatID = kAudioFormatLinearPCM;
        fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        fmt.mFramesPerPacket = 1;
        fmt.mChannelsPerFrame = 1;
        fmt.mBitsPerChannel = 16;
        fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
        fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
        
        
        OSStatus status;
        
        status = AudioQueueNewOutput(&fmt, audioqueue_osc1_callback, (__bridge void*)self, NULL, NULL, 0, &queueOsc1);
        for (int i=0; i < kNumBuffers; i++) {
            status = AudioQueueAllocateBuffer(queueOsc1, kBufferSize, &buffersOsc1[i]);
            AudioQueueBuffer *buffer = buffersOsc1[i];
            buffer->mAudioDataByteSize = kBufferSize;
        }
        
        status = AudioQueueNewOutput(&fmt, audioqueue_osc2_callback, (__bridge void*)self, NULL, NULL, 0, &queueOsc2);
        for (int i=0; i < kNumBuffers; i++) {
            status = AudioQueueAllocateBuffer(queueOsc2, kBufferSize, &buffersOsc2[i]);
            AudioQueueBuffer *buffer = buffersOsc2[i];
            buffer->mAudioDataByteSize = kBufferSize;
        }

        [self primeBuffers];
        status = AudioQueueSetParameter (queueOsc1, kAudioQueueParam_Volume, 1.0);
        status = AudioQueueSetParameter (queueOsc2, kAudioQueueParam_Volume, 1.0);
        

    }
     
    return self;
}

- (void)start
{
    AudioQueueStart(queueOsc1, NULL);
    AudioQueueStart(queueOsc2, NULL);
}
- (void)stop
{
    AudioQueueStop(queueOsc1, true);
    AudioQueueStop(queueOsc2, true);
}


- (void)primeBuffers
{
    for (int i=0; i < kNumBuffers; i++) {
        audioqueue_osc1_callback((__bridge void*)self, queueOsc1, buffersOsc1[i]);
        audioqueue_osc2_callback((__bridge void*)self, queueOsc2, buffersOsc2[i]);
    }
}

//- (int) getSamples :(short *)samples :(int)numSamples
//{
//    [osc1 getSamples:samples :numSamples];
//    
//    if (osc2Enabled) {
//        [osc2 mixSamples:samples :numSamples];
//    }
//    
//    if (vcfEnabled) {
//        [vcf modifySamples:samples :numSamples];
//    }
//    if (vcaEnabled) {
//        [vca modifySamples:samples :numSamples];
//    }
//    
////    @autoreleasepool {
////        if (analyzer) {
////            [analyzer receiveSamples:samples :numSamples];
////        }
////    }
//    return numSamples;
//}



- (void)noteOn
{        
    [self stop];
    [super noteOn];
    [self primeBuffers];
    [self start];
}

- (void)noteOff
{
    [super noteOff];   
}


@end
