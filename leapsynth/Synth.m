//
//  Synth.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Synth.h"

@implementation Synth


- (id)init
{

    if (self) {
        self = [super init];
    
        for (int i=0; i < kNumOscillators; i++) {
            oscN[i] = [[Vco alloc] init];
        }
        for (int i=0; i < kNumEnvelopes; i++) {
            adsrN[i] = [[Adsr alloc] init];
        }

        lfo = [[Oscillator alloc] init];
        noise = [[NoiseGenerator alloc] init];
        vcf = [[Vcf alloc] init];
        
        for (int i=0; i < kNumMixers; i++) {
            mixerN[i] = [[Mixer alloc] init];
        }

    }
    
    return self;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    
    BOOL foundOne = NO;
    for (int i=0; i < kNumMixers; i++) {
        if ([mixerN[i] level] > 0) {
            if (foundOne) {
                [mixerN[i] mixSamples:samples :numSamples];
            } else {
                [mixerN[i] getSamples:samples :numSamples];
                foundOne = YES;
            }
        }
    }
    
    return numSamples;
}

- (void)noteOn
{
    for (int i=0; i < kNumEnvelopes; i++) {
        [adsrN[i] noteOn];
    }
}

- (void)noteOff
{
    for (int i=0; i < kNumEnvelopes; i++) {
        [adsrN[i] noteOff];
    }
}

- (void)setFrequencyInHz:(double)freqInHz
{
    for (int i=0; i < kNumOscillators; i++) {
        [oscN[i] setFrequencyInHz:freqInHz];
    }
}

@end
