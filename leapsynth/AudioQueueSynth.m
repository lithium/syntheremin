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
@synthesize vca;


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

    if ([synth oscEnabled:args->whichOsc]) {
        [synth->oscN[args->whichOsc] getSamples:samples :num_samples];
    
        if (synth->vcfEnabled) {
            [synth->vcfN[args->whichOsc] modifySamples:samples :num_samples];
        }
//        if (synth->vcaEnabled) {
            [synth->vca modifySamples:samples :num_samples];
//        }
    } 

    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}


- (id) init
{
    if (self) {
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

        vca = [[Vca alloc] init];        

        for (int i=0; i < kNumOscillators; i++) {
            oscN[i] = [[Vco alloc] init];
            [oscN[i] setWaveShape:kWaveSaw];
            [oscN[i] setFrequency:440];
            [oscN[i] setLevel:1.0];
            oscEnabled[i] = NO;

            vcfN[i] = [[Vcf alloc] init];
            [vcfN[i] setCutoffFrequencyInHz:1000];
            [vcfN[i] setResonance:0.85];
            [vcfN[i] setDepth:2.0];
        
            callbackArgs[i].self = (__bridge void*)self;
            callbackArgs[i].whichOsc = i;
        
            status = AudioQueueNewOutput(&fmt, audioqueue_osc_callback, (void*)&callbackArgs[i], NULL, NULL, 0, &queueOsc[i]);
            for (int n=0; n < kNumBuffers; n++) {
                status = AudioQueueAllocateBuffer(queueOsc[i], kBufferSize, &buffersOsc[i][n]);
                buffersOsc[i][n]->mAudioDataByteSize = kBufferSize;
            }
            status = AudioQueueSetParameter (queueOsc[i], kAudioQueueParam_Volume, 1.0);

        }
        
        [self primeBuffers];

    }
     
    return self;
}

- (void)start
{
    for (int i=0; i < kNumOscillators; i++) {
        AudioQueueStart(queueOsc[i], NULL);
    }
}
- (void)stop
{    
    for (int i=0; i < kNumOscillators; i++) {
        AudioQueueStop(queueOsc[i], true);
    }
}


- (void)primeBuffers
{
    for (int i=0; i < kNumOscillators; i++) {
        for (int n=0; n < kNumBuffers; n++) {
            audioqueue_osc_callback((void*)&callbackArgs[i], queueOsc[i], buffersOsc[i][n]);
        }
    }
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
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setAttackTimeInMs:ms];
    }
}
- (void)setVcfDecayTimeInMs:(int)ms
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setDecayTimeInMs:ms];
        [vcfN[i] setReleaseTimeInMs:ms];
    }
}
- (void)setVcfSustainLevel:(double)level
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setSustainLevel:level];
    }
}
- (void)setVcfCutoffInHz:(double)freqInHz
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setCutoffFrequencyInHz:freqInHz];
    }
}
- (void)setVcfResonance:(double)level
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setResonance:level];
    }
}
- (void)setVcfDepth:(double)level
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setDepth:level];
    }
}
- (void)setVcfEnvelopeEnabled:(bool)enabled
{
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] setEnvelopeEnabled:enabled];
    }
}
- (void)setFrequencyInHz:(double)freqInHz
{
    for (int i=0; i < kNumOscillators; i++) {
        [oscN[i] setFrequency:freqInHz];
    }
}


- (void)noteOn
{        
    [self stop];
    [vca noteOn];
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] noteOn];
    }
    [self primeBuffers];
    [self start];
}

- (void)noteOff
{
    [vca noteOff];
    for (int i=0; i < kNumOscillators; i++) {
        [vcfN[i] noteOff];
    }
}


@end
