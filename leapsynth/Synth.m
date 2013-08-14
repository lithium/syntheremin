//
//  Synth.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Synth.h"

@implementation Synth

@synthesize vco;
@synthesize vca;
@synthesize vcf;
@synthesize vcfEnabled;
@synthesize vcaEnabled;
@synthesize analyzer;

- (id)init
{
    vco = [[Vco alloc] init];
    [vco setWaveShape:kWaveSquare];
    [vco setFrequency:440];

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
    [vco getSamples:samples :numSamples];
    
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
