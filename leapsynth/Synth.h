//
//  Synth.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vco.h"
#import "Vca.h"
#import "Vcf.h"
//#import "SynthAnalyzer.h"
#import "NoiseGenerator.h"
#import "Adsr.h"
#import "SampleProvider.h"
#import "Mixer.h"

#define kNumMixers 4

//@protocol AnalyzerDelegate <NSObject>
//- (void) receiveSamples :(short *)samples :(int)numSamples;
//@end

@interface Synth : SampleProvider {
    Vco *oscN[kNumOscillators];
    Oscillator *lfo;
    NoiseGenerator *noise;
    Vcf *vcf;
    Adsr *adsrN[kNumEnvelopes];
    Mixer *mixerN[kNumMixers];
}


- (id)init;
- (int) getSamples :(short *)samples :(int)numSamples;
- (void)setFrequencyInHz:(double)freqInHz;


- (void)noteOn;
- (void)noteOff;

@end
