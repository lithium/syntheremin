//
//  AudioQueueSynth.m
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AudioQueueSynth.h"
@implementation AudioQueueSynth

@synthesize vcfEnabled;
@synthesize vcaEnabled;
@synthesize noiseEnabled;
@synthesize vca;
@synthesize looper;


static void audioqueue_osc_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    struct CallbackArg *args = (struct CallbackArg *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    AudioQueueSynth *synth = (__bridge AudioQueueSynth *)args->self;
    
    for (int i=0; i < num_samples; i++) {
        samples[i] = 0;
    }
    
    BOOL foundOsc = NO;
    for (int i=0; i < kNumOscillators; i++) {
        if ([synth oscEnabled:i]) {
            if (foundOsc) {
                [synth->oscN[i] mixSamples:samples :num_samples];
            } else {
                foundOsc=YES;
                [synth->oscN[i] getSamples:samples :num_samples];
            }
        }
    }
    if (synth->noiseEnabled) {
        if (foundOsc) {
           [synth->noise mixSamples:samples :num_samples];
        } else {
            [synth->noise getSamples:samples :num_samples];
        }
    }

        
    if (synth->vcfEnabled) {
        [synth->vcf modifySamples:samples :num_samples];
    }
    [synth->vca modifySamples:samples :num_samples];
    
    [synth->looper recordSamples:samples :num_samples];

    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}


- (id) init
{
    if (self) {
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

        vca = [[Vca alloc] init];        
        vcf = [[Vcf alloc] init];
        [vcf setCutoffFrequencyInHz:1000];
        [vcf setResonance:0.85];
        [vcf setDepth:2.0];
        
        noise = [[NoiseGenerator alloc] init];

        for (int i=0; i < kNumOscillators; i++) {
            oscN[i] = [[Vco alloc] init];
            [oscN[i] setWaveShape:kWaveSaw];
            [oscN[i] setFrequency:440];
            [oscN[i] setLevel:1.0];
            oscEnabled[i] = NO;
        }
        
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



- (void)setOscEnabled:(int)which :(bool)enabled
{
    oscEnabled[which] = enabled;
}
- (bool)oscEnabled:(int)which
{
    return oscEnabled[which];
}

- (void)setOscVolume:(int)which :(double)level
{
    [oscN[which] setLevel:level];
}
- (double)oscVolume:(int)which
{
    return [oscN[which] level];
}
- (Vco *)oscN:(int)which
{
    return oscN[which];
}
- (void)setVcfAttackTimeInMs:(int)ms
{
    [vcf setAttackTimeInMs:ms];
}
- (void)setVcfDecayTimeInMs:(int)ms
{
    [vcf setDecayTimeInMs:ms];
    [vcf setReleaseTimeInMs:ms];
}
- (void)setVcfSustainLevel:(double)level
{
    [vcf setSustainLevel:level];
}
- (void)setVcfCutoffInHz:(double)freqInHz
{
    [vcf setCutoffFrequencyInHz:freqInHz];
}
- (void)setVcfResonance:(double)level
{
    [vcf setResonance:level];
}
- (void)setVcfDepth:(double)level
{
    [vcf setDepth:level];
}
- (void)setVcfEnvelopeEnabled:(bool)enabled
{
    [vcf setEnvelopeEnabled:enabled];
}
- (void)setFrequencyInHz:(double)freqInHz
{
    for (int i=0; i < kNumOscillators; i++) {
        [oscN[i] setFrequency:freqInHz];
    }
}


- (void)noteOn
{        
    for (int i=0; i < kNumOscillators; i++) {
        AudioQueueFlush(queueOsc);
    }

    [vca noteOn];
    [vcf noteOn];
}

- (void)noteOff
{
    [vca noteOff];
    [vcf noteOff];
}


@end
