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
    
    return self;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    [vco getSamples:samples :numSamples];
    
    
    [vca modifySamples:samples :numSamples];
}


@end
