//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize osc2_freq;

@synthesize window = _window;


void audio_queue_output_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    WaveData *wave = userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *sample = buffer->mAudioData;
    
    int i;
    for (i=0; i < num_samples; i++) {
       sample[i] = (int)(sinf(wave->phase) * 32767.0);
        wave->phase += wave->step;
    }
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    OSStatus status;
    
    mWaveform.phase = 0;
    mWaveform.frequency = 220;
    mWaveform.step = 2 * M_PI * mWaveform.frequency / kSampleRate;
    
    AudioStreamBasicDescription fmt = {0};
    fmt.mSampleRate = kSampleRate;
    fmt.mFormatID = kAudioFormatLinearPCM;
    fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt.mFramesPerPacket = 1;
    fmt.mChannelsPerFrame = 1;
    fmt.mBitsPerChannel = 16;
    fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
    fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
    
    
    
    status = AudioQueueNewOutput(&fmt, audio_queue_output_callback, &mWaveform, NULL, NULL, 0, &mAudioQueue);
    
    for (int i=0; i < kNumBuffers; i++) {
        status = AudioQueueAllocateBuffer(mAudioQueue, kBufferSize, &mQueueBuffers[i]);
        AudioQueueBuffer *buffer = mQueueBuffers[i];
        buffer->mAudioDataByteSize = kBufferSize;
        audio_queue_output_callback(&mWaveform, mAudioQueue, mQueueBuffers[i]);
    }
    
    status = AudioQueueSetParameter (mAudioQueue, kAudioQueueParam_Volume, 1.0);

    status = AudioQueueStart(mAudioQueue, NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
}

- (void)windowWillClose:(NSNotification *)notification
{
    AudioQueueStop(mAudioQueue, true);
}


- (IBAction)takeIntValueForFrequencyFrom:(id)sender {
    int freq = [sender intValue];
    mWaveform.phase = 0;
    mWaveform.frequency = freq;
    mWaveform.step = 2 * M_PI * mWaveform.frequency / kSampleRate;

}
@end
