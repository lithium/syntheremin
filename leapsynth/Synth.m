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

        
        
        //hardcode a patch for debugging
        [oscN[0] setWaveShape:kWaveSaw];
        [oscN[0] setFrequencyInHz:440];
        [oscN[0] setRange:0];
    
        [oscN[1] setWaveShape:kWaveSaw];
        [oscN[1] setFrequencyInHz:440];
        [oscN[1] setRange:1];
        
        [oscN[2] setWaveShape:kWaveSaw];
        [oscN[2] setFrequencyInHz:440];
        [oscN[2] setRange:2];


        
        [lfo setFrequencyInHz:8];
        [lfo setWaveShape:kWaveSine];
        [lfo setLevel:0.5];
        
        [vcf addInput:oscN[0]];
        [vcf addInput:oscN[1]];
        [vcf addInput:oscN[2]];
        [vcf setCutoffFrequencyInHz:1000];
        [vcf setResonance:0.8];
        
        [vcf setModulator:lfo];
        
        [vcaN[0] addInput:vcf];
        [vcaN[0] setLevel:0.8];

        
        [adsrN[0] setAttackTimeInMs:0];
        [adsrN[0] setDecayTimeInMs:0];
        [adsrN[0] setSustainLevel:1.0];
        [adsrN[0] setReleaseTimeInMs:0];
        [vcaN[0] setModulator:adsrN[0]];
        
        
        


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
