//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Vco.h"

@implementation Vco

@synthesize frequencyModulation;
@synthesize amplitudeModulation;


- (id)init
{
    lfo = [[Oscillator alloc] init];
    rangeMultiplier = 1.0;
    detuneMultiplier = 1.0;
    frequencyModulation = 0.0;
    amplitudeModulation = 0.0;
    return self;
}


- (void)setRange :(int)octave
{
    switch (octave) {
        case -2:
            rangeMultiplier = 0.25;
            break;
        case -1:
            rangeMultiplier = 0.5;
            break;
        default:
        case 0:
            rangeMultiplier = 1.0;
            break;
        case 1:
            rangeMultiplier = 2.0;
            break;
        case 2:
            rangeMultiplier = 4.0;
            break;
    }
}

- (void)setFrequency :(double)frequencyInHz
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
        
    detuneMultiplier = pow(2.0, (double)((double)cents / kCentsPerOctave));
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
    if (frequencyModulation > 0) {
        double lfoSample = [lfo getSample] * frequencyModulation;
        freq *= pow(2.0, lfoSample);
    }
    
    freq *= rangeMultiplier;
    freq /= detuneMultiplier;
    
    [super setFrequency:freq];
    double sample = [super getSample];
    
    if (amplitudeModulation > 0) {
        double lfoOffset = ([lfo getSample] + 1.0) / 2.0;
        double m = 1.0 - (amplitudeModulation * lfoOffset);
        sample *= m;
    }
    
    return sample;
}
@end
