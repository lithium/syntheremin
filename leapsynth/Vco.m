//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Vco.h"

@implementation Vco

@synthesize modulationType;
@synthesize modulationDepth;
@synthesize rangeMultiplier;


- (id)init
{
    lfo = [[Oscillator alloc] init];
    rangeMultiplier = 1.0;
    detuneMultiplier = 1.0;
    modulationType = kModulationTypeNone;
    return self;
}



- (void)setFrequency :(int)frequencyInHz
{
    frequency = frequencyInHz;
}

- (void)setDetuneInCents :(int)cents
{
    if (cents == 0)
        detuneMultiplier = 1.0;
    else if (cents < kCentsDetuneMin)
        detuneMultiplier = kCentsDetuneMin;
    else if (cents > kCentsDetuneMax)
        detuneMultiplier = kCentsDetuneMax;
        
    detuneMultiplier = pow(2.0, (double)(cents / kCentsPerOctave));
}

- (void)setLfoWaveshape :(int)shape
{
    [lfo setWaveShape :shape];

}

- (void)setLfoFrequency :(double)frequencyInHz
{
    [lfo setFrequency :frequencyInHz];
}

- (double)getSample
{
    double freq = frequency;
    if ((modulationType == kModulationTypeFrequency) && (modulationDepth != 0)) {
        double lfoSample = [lfo getSample] * modulationDepth;
        freq *= pow(2.0, lfoSample);
    }
    
    freq *= rangeMultiplier;
    freq *= detuneMultiplier;
    [self setFrequency :freq];
    
    double sample = [self getSample];
    
    if (modulationType == kModulationTypeAmplitude) {
        double lfoOffset = ([lfo getSample] + 1.0) / 2.0;
        double m = 1.0 - (modulationDepth * lfoOffset);
        sample *= m;
    }
    
    return sample;
}
@end
