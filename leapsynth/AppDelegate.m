//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize keyboard_1;
@synthesize keyboard_2;
@synthesize keyboard_3;
@synthesize keyboard_4;
@synthesize keyboard_5;
@synthesize cv_1;
@synthesize cv_2;
@synthesize cv_3;
@synthesize cv_4;
@synthesize cv_5;
@synthesize osc1_shape;
@synthesize osc1_range;
@synthesize osc1_detune;
@synthesize osc2_shape;
@synthesize osc2_freq;
@synthesize osc2_fm;
@synthesize osc2_am;

@synthesize window = _window;


void audio_queue_output_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    Synth *synth = (__bridge Synth *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    [synth getSamples:samples :num_samples];
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    OSStatus status;
    
    synth = [[Synth alloc] init];
        
    AudioStreamBasicDescription fmt = {0};
    fmt.mSampleRate = kSampleRate;
    fmt.mFormatID = kAudioFormatLinearPCM;
    fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt.mFramesPerPacket = 1;
    fmt.mChannelsPerFrame = 1;
    fmt.mBitsPerChannel = 16;
    fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
    fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
    
    
    status = AudioQueueNewOutput(&fmt, audio_queue_output_callback, (__bridge void*)synth, NULL, NULL, 0, &mAudioQueue);
    
    for (int i=0; i < kNumBuffers; i++) {
        status = AudioQueueAllocateBuffer(mAudioQueue, kBufferSize, &mQueueBuffers[i]);
        AudioQueueBuffer *buffer = mQueueBuffers[i];
        buffer->mAudioDataByteSize = kBufferSize;
    }
    [self primeBuffers];
    
    status = AudioQueueSetParameter (mAudioQueue, kAudioQueueParam_Volume, 1.0);

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    [keyboard_1 setDelegate:self];
    [keyboard_2 setDelegate:self];
    [keyboard_3 setDelegate:self];
    [keyboard_4 setDelegate:self];
    [keyboard_5 setDelegate:self];
    
    AudioQueueStart(mAudioQueue, NULL);


}


- (void)primeBuffers
{
    for (int i=0; i < kNumBuffers; i++) {
        audio_queue_output_callback((__bridge void*)synth, mAudioQueue, mQueueBuffers[i]);
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    AudioQueueStop(mAudioQueue, true);
}


- (IBAction)setVcoShape:(id)sender {
    [[synth vco] setWaveShape:[osc1_shape intValue]];
//    AudioQueueStop(mAudioQueue, true);
    [self primeBuffers];
//    AudioQueueStart(mAudioQueue, NULL);


}

- (IBAction)setVcoRange:(id)sender {
    int value = [osc1_range intValue];
    [[synth vco] setRange:(2 - value)];
}

- (IBAction)setVcoDetune:(id)sender {
    int value = [osc1_detune intValue];
    [[synth vco] setDetuneInCents:value];
}

- (IBAction)setLfoShape:(id)sender {
    int shape = [osc2_shape intValue];
    [[synth vco] setLfoWaveshape:shape];
}

- (IBAction)setLfoFrequency:(id)sender {
    [[synth vco] setLfoFrequency:[osc2_freq doubleValue]];
}

- (IBAction)setFmDepth:(id)sender {
    [[synth vco] setFrequencyModulation:[osc2_fm doubleValue]];
}

- (IBAction)setAmDepth:(id)sender {
    [[synth vco] setAmplitudeModulation:[osc2_am doubleValue]];
}


- (void)mouseDown:(NSEvent *)evt :(int)tag {
    NSLog(@"%d note on", tag);
    double freq=440;
    switch (tag) {
        case 100:
            freq += [cv_1 intValue]; 
            break;
        case 101:
            freq += [cv_2 intValue]; 
            break;
        case 102:
            freq += [cv_3 intValue]; 
            break;
        case 103:
            freq += [cv_4 intValue]; 
            break;
        case 104:
            freq += [cv_5 intValue]; 
            break;
    }
    [[synth vco] setFrequency:freq];
    
    [self noteOn];

}
- (void)mouseUp:(NSEvent *)evt :(int)tag {
    NSLog(@"%d note off", tag);
//    AudioQueueStop(mAudioQueue, true);
    [self noteOff];
}

- (void)noteOn
{    
    [[synth vca] noteOn];
    AudioQueueStop(mAudioQueue, true);
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);
}

- (void)noteOff
{
    [[synth vca] noteOff];
//    AudioQueueStop(mAudioQueue, true);
}

@end
