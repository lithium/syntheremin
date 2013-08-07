//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize vca_master;
@synthesize vcf_enable;
@synthesize lefthand_x;
@synthesize lefthand_y;
@synthesize lefthand_z;
@synthesize righthand_x;
@synthesize righthand_y;
@synthesize righthand_z;
@synthesize lefthand_x_popup;
@synthesize lefthand_y_popup;
@synthesize lefthand_z_popup;
@synthesize righthand_x_popup;
@synthesize righthand_y_popup;
@synthesize righthand_z_popup;

@synthesize vcf_cutoff;
@synthesize vcf_resonance;
@synthesize vcf_depth;
@synthesize vcf_attack;
@synthesize vcf_decay;
@synthesize vcf_sustain;
@synthesize vcf_release;
@synthesize vca_attack;
@synthesize vca_decay;
@synthesize vca_sustain;
@synthesize vca_release;
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
    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    
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
    
    
    mSyntheremin = [[LeapSyntheremin alloc] init];
    [mSyntheremin setDelegate:self];
    
    
    [self setLeftParamX:kParameterNone];
    [self setLeftParamY:kParameterVolume];
    [self setLeftParamZ:kParameterNone];

    [self setRightParamX:kParameterPitch];
    [self setRightParamY:kParameterNone];
    [self setRightParamZ:kParameterNone];




}

- (void)setLeftParamX:(int)param
{
    leftParamX = param;    
    [lefthand_x_popup selectItemWithTag:param];
}
- (void)setLeftParamY:(int)param
{
    leftParamY = param;    
    [lefthand_y_popup selectItemWithTag:param];
}
- (void)setLeftParamZ:(int)param
{
    leftParamZ = param;    
    [lefthand_z_popup selectItemWithTag:param];
}
- (void)setRightParamX:(int)param
{
    rightParamX = param;    
    [righthand_x_popup selectItemWithTag:param];
}
- (void)setRightParamY:(int)param
{
    rightParamY = param;    
    [righthand_y_popup selectItemWithTag:param];
}
- (void)setRightParamZ:(int)param
{
    rightParamZ = param;    
    [righthand_z_popup selectItemWithTag:param];
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
    AudioQueueStop(mAudioQueue, true);
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);
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

- (IBAction)setVcaMaster:(id)sender;
{
    [[synth vca] setMasterVolume:[vca_master doubleValue]];
}
- (IBAction)setVcaAttack:(id)sender
{
    [[synth vca] setAttackTimeInMs:[vca_attack intValue]];
}

- (IBAction)setVcaDecay:(id)sender
{
    [[synth vca] setDecayTimeInMs:[vca_decay intValue]];

}

- (IBAction)setVcaSustain:(id)sender
{
    [[synth vca] setSustainLevel:[vca_sustain doubleValue]];

}
- (IBAction)setVcaRelease:(id)sender
{
    [[synth vca] setReleaseTimeInMs:[vca_release intValue]];

}

- (IBAction)setVcfAttack:(id)sender
{
    [[synth vcf] setAttackTimeInMs:[vcf_attack intValue]];
}

- (IBAction)setVcfDecay:(id)sender
{
    [[synth vcf] setDecayTimeInMs:[vcf_decay intValue]];
    
}

- (IBAction)setVcfSustain:(id)sender
{
    [[synth vcf] setSustainLevel:[vcf_sustain doubleValue]];
    
}
- (IBAction)setVcfRelease:(id)sender
{
    [[synth vcf] setReleaseTimeInMs:[vcf_release intValue]];
    
}
- (IBAction)setVcfCutoff:(id)sender
{
    [[synth vcf] setCutoffFrequencyInHz:[vcf_cutoff intValue]];
}
- (IBAction)setVcfResonance:(id)sender
{
    [[synth vcf] setResonance:[vcf_resonance doubleValue]];
}
- (IBAction)setVcfDepth:(id)sender
{
    double depth = [vcf_depth doubleValue];
    [[synth vcf] setDepth:depth];
}

- (IBAction)toggleFilter:(id)sender {
    int state = [vcf_enable state];
    [synth setVcfEnabled:state];
}

- (void)mouseDown:(NSEvent *)evt :(int)tag {
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
    [self noteOff];
}

- (double)translateMinMax:(double)pos :(double)min :(double)max
{
    return (abs(pos) + abs(min))/(abs(min)+abs(max));
}

//
//X: -200 ..  0  .. 200
//Y:   50 .. 175 .. 400
//Z: -120 ..  0  .. 120
- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)position
{
    double x = fabs([position x]/200.0);
    double y = fabs(([position y]-50)/350.0);
    double z = fabs([position z]/120.0);

    [lefthand_x setDoubleValue:x];
    [lefthand_y setDoubleValue:y];
    [lefthand_z setDoubleValue:z];
    
    [self applyParameter:leftParamX :x];
    [self applyParameter:leftParamY :y];
    [self applyParameter:leftParamZ :z];
    
}
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)position
{
//    NSLog(@"Right hand: %f,%f,%f", [position x], [position y], [position z]);
    double x = fabs([position x]/200.0);
    double y = fabs(([position y]-50)/350.0);
    double z = fabs([position z]/120.0);
    
    [righthand_x setDoubleValue:x];
    [righthand_y setDoubleValue:y];
    [righthand_z setDoubleValue:z];
    
    [self applyParameter:rightParamX :x];
    [self applyParameter:rightParamY :y];
    [self applyParameter:rightParamZ :z];

}

- (void)applyParameter:(int)param :(double)value
{
    switch (param) {
        case kParameterVolume:
            [[synth vca] setMasterVolume:value];
            break;
        case kParameterPitch: {
            double freq = value*(kFrequencyMax-kFrequencyMin)+kFrequencyMin;
            [[synth vco] setFrequency:freq];
            break;
        }
        case kParameterFrequency: {
            double freq = value*(kFrequencyMax-kFrequencyMin)+kFrequencyMin;
            [[synth vcf] setCutoffFrequencyInHz:freq];
            break;
        }
        case kParameterResonance: {
            [[synth vcf] setResonance:value];
            break;
        }
    }
}

- (IBAction)setParameter:(id)sender
{
    switch ([sender tag]) {
        case 1:    
            leftParamX = [sender selectedTag];
            break;
        case 2:    
            leftParamY = [sender selectedTag];
            break;
        case 3:    
            leftParamZ = [sender selectedTag];
            break;
        case 4:    
            rightParamX = [sender selectedTag];
            break;
        case 5:    
            rightParamY = [sender selectedTag];
            break;
        case 6:    
            rightParamZ = [sender selectedTag];
            break;

    }

}

- (void)noteOn
{        
    AudioQueueStop(mAudioQueue, true);
    [synth noteOn];
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);
}

- (void)noteOff
{
    [synth noteOff];
}

@end
