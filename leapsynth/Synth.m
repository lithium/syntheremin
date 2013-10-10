//
//  Synth.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Synth.h"

@implementation Synth

@synthesize osc1;
@synthesize osc2;
@synthesize vca;
@synthesize vcf;
@synthesize vcfEnabled;
@synthesize vcaEnabled;
@synthesize osc2Enabled;
@synthesize analyzer;

- (id)init
{
    osc1 = [[Vco alloc] init];
    [osc1 setWaveShape:kWaveSquare];
    [osc1 setFrequency:440];
    
    osc2 = [[Vco alloc] init];
    [osc2 setWaveShape:kWaveSquare];
    [osc2 setFrequency:880];


    vca = [[Vca alloc] init];
    [vca setAttackTimeInMs:600];
    [vca setDecayTimeInMs:200];
    [vca setSustainLevel:0.2];
    [vca setReleaseTimeInMs:1000];
    
    vcf = [[Vcf alloc] init];
    [vcf  setCutoffFrequencyInHz:1000];
    [vcf setResonance:0.85];
    [vcf setDepth:2.0];
    
    
    vcaEnabled = true;
    vcfEnabled = true;
    [vca setEnvelopeEnabled:false];
    [vcf setEnvelopeEnabled:false];

    
    return self;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    [osc1 getSamples:samples :numSamples];
    
    if (osc2Enabled) {
        [osc2 mixSamples:samples :numSamples];
    }
    
    if (vcfEnabled) {
        [vcf modifySamples:samples :numSamples];
    }
    if (vcaEnabled) {
        [vca modifySamples:samples :numSamples];
    }
    
    @autoreleasepool {
        if (analyzer) {
            [analyzer receiveSamples:samples :numSamples];
        }
    }
    return numSamples;
}

- (void)noteOn
{
    [vca noteOn];
    [vcf noteOn];
}

- (void)noteOff
{
    [vca noteOff];
    [vcf noteOff];
}

@end
