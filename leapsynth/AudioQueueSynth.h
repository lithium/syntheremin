//
//  AudioQueueSynth.h
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Synth.h"
#import "AudioToolbox/AudioQueue.h"

#define kNumOscillators 3

struct CallbackArg {
    void *self;
    int whichOsc;
};

@interface AudioQueueSynth : NSObject
{
    AudioQueueRef queueOsc[kNumOscillators];
    AudioQueueBufferRef buffersOsc[kNumOscillators][kNumBuffers];

    Vco *oscN[kNumOscillators];
    Vcf *vcfN[kNumOscillators];
    Vca *vca;
        
    struct CallbackArg callbackArgs[kNumOscillators];

    bool oscEnabled[kNumOscillators];
    bool vcfEnabled;
    bool vcaEnabled;
}

@property bool vcfEnabled;
@property bool vcaEnabled;
@property Vca *vca;

- (void)setOscEnabled:(int)which :(bool)enabled;
- (void)setOscVolume:(int)which :(double)level;
- (bool)oscEnabled:(int)which;
- (double)oscVolume:(int)which;

- (Vco *)oscN:(int)which;

- (void)setVcfAttackTimeInMs:(int)ms;
- (void)setVcfDecayTimeInMs:(int)ms;
- (void)setVcfSustainLevel:(double)level;
- (void)setVcfCutoffInHz:(double)freqInHz;
- (void)setVcfResonance:(double)level;
- (void)setVcfDepth:(double)level;
- (void)setVcfEnvelopeEnabled:(bool)enabled;

- (void)setFrequencyInHz:(double)freqInHz;

- (void)start;
- (void)stop;
- (void)noteOn;
- (void)noteOff;
- (void)primeBuffers;

@end

