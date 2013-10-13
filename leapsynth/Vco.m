//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vco.h"

@implementation Vco

@synthesize modulationType;


- (id)init
{
    if (self) {
        self = [super init];
        
        rangeMultiplier = 1.0;
        detuneMultiplier = 1.0;
        [self setModulationType:kModulationTypeNone];
    }
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


- (double)getSample
{
    double freq = [self getFrequencyInHz];
    if (modulationType == kModulationTypeFrequency) {
        freq *= pow(2.0, [self getModulationSample]);
    }
    
    freq *= rangeMultiplier;
    freq /= detuneMultiplier;
    
    [super setFrequencyInHz:freq];
    double sample = [super getSample];
    
    if (modulationType == kModulationTypeAmplitude) {
        double m = 1.0 - ([self getModulationSample] + 1.0) / 2.0;
        sample *= m;
    }
    
    return sample;
}
@end
