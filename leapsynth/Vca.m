//
//  Vca.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vca.h"

@implementation Vca
@synthesize envelopeEnabled;
@synthesize masterVolume;

- (id)init
{
    [self setAttackTimeInMs:1];
    [self setDecayTimeInMs:1000];
    [self setSustainLevel:0.5];
    [self setReleaseTimeInMs:2000];
    
    masterVolume = 1.0;
    return self;
}

- (double)getValue
{
    double value = masterVolume;
    if (envelopeEnabled) {
        value *= [super getValue];
    }
    return value;
}

- (int) modifySamples :(short *)samples :(int)numSamples
{
    int i;
    for (i=0; i < numSamples; i++) {
        double value = [self getValue];
        samples[i] *= value;
    }
    return numSamples;
}

@end
