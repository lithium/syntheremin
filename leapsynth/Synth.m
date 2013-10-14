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
            vcaN[i] = [[Vca alloc] init];
            [vcaN[i] setLevel:0];
        }

        
        
        [oscN[0] setWaveShape:kWaveSaw];
        [oscN[0] setFrequencyInHz:440];
        
        [vcaN[0] addInput:oscN[0]];
        [vcaN[0] setLevel:0.6];


//        [oscN[1] setWaveShape:kWaveSaw];
//        [oscN[1] setFrequencyInHz:220];
//        [vcaN[1] addInput:oscN[1]];
        
        [lfo setWaveShape:kWaveSine];
        [lfo setFrequencyInHz:2];
        [lfo setLevel:1.0];
        [vcaN[0] setModulator:lfo];
        


//        [vcaN[0] setModulator:lfo];
//        [vcaN[1] setLevel:0.6];
    }
    
    return self;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    
    BOOL foundOne = NO;
    for (int i=0; i < kNumMixers; i++) {
        if ([vcaN[i] level] > 0) {
            if (foundOne) {
                [vcaN[i] mixSamples:samples :numSamples];
            } else {
                [vcaN[i] getSamples:samples :numSamples];
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
