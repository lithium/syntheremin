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
    Vco *vco = (__bridge Vco *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    [vco getSamples:samples :num_samples];
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    OSStatus status;
    
    vco = [[Vco alloc] init];
    [vco setWaveShape:kWaveSquare];
//    [vco setModulationType:kModulationTypeFrequency];
//    [vco setLfoFrequency:0];
//    [vco setLfoWaveshape:kWaveSine];
    [vco setFrequency:440];
        
    AudioStreamBasicDescription fmt = {0};
    fmt.mSampleRate = kSampleRate;
    fmt.mFormatID = kAudioFormatLinearPCM;
    fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt.mFramesPerPacket = 1;
    fmt.mChannelsPerFrame = 1;
    fmt.mBitsPerChannel = 16;
    fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
    fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
    
    
    status = AudioQueueNewOutput(&fmt, audio_queue_output_callback, (__bridge void*)vco, NULL, NULL, 0, &mAudioQueue);
    
    for (int i=0; i < kNumBuffers; i++) {
        status = AudioQueueAllocateBuffer(mAudioQueue, kBufferSize, &mQueueBuffers[i]);
        AudioQueueBuffer *buffer = mQueueBuffers[i];
        buffer->mAudioDataByteSize = kBufferSize;
        audio_queue_output_callback((__bridge void*)vco, mAudioQueue, mQueueBuffers[i]);
    }
    
    status = AudioQueueSetParameter (mAudioQueue, kAudioQueueParam_Volume, 1.0);

    status = AudioQueueStart(mAudioQueue, NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    
    [keyboard_1 setDelegate:self];
    [keyboard_2 setDelegate:self];
}


- (void)primeBuffers
{
    for (int i=0; i < kNumBuffers; i++) {
        AudioQueueBuffer *buffer = mQueueBuffers[i];
        audio_queue_output_callback((__bridge void*)vco, mAudioQueue, mQueueBuffers[i]);
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    AudioQueueStop(mAudioQueue, true);
}


- (IBAction)setVcoShape:(id)sender {
    [vco setWaveShape:[osc1_shape intValue]];
    AudioQueueStop(mAudioQueue, true);
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);


}

- (IBAction)setVcoRange:(id)sender {
    int value = [osc1_range intValue];
    [vco setRange:(2 - value)];
}

- (IBAction)setVcoDetune:(id)sender {
    int value = [osc1_detune intValue];
    [vco setDetuneInCents:value];
}

- (IBAction)setLfoShape:(id)sender {
    int shape = [osc2_shape intValue];
    [vco setLfoWaveshape:shape];
}

- (IBAction)setLfoFrequency:(id)sender {
    [vco setLfoFrequency:[osc2_freq doubleValue]];
}

- (IBAction)setFmDepth:(id)sender {
    [vco setFrequencyModulation:[osc2_fm doubleValue]];
}

- (IBAction)setAmDepth:(id)sender {
    [vco setAmplitudeModulation:[osc2_am doubleValue]];
}


- (void)mouseDown:(NSEvent *)evt :(int)tag {
    NSLog(@"%d note on", tag);

}
- (void)mouseUp:(NSEvent *)evt :(int)tag {
    NSLog(@"%d note off", tag);

}

@end
