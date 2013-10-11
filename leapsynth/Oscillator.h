//
//  Vco.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

enum  {
    kWaveSquare=0,
    kWaveSine=1,
    kWaveSaw=2,
    kWaveTriangle=3,
};

@interface Oscillator : NSObject {
    int waveShape;
    long samplesPerPeriod;
    long sampleStep;
    double level;
}

@property int waveShape;
@property double level;

- (id) init;
- (void) setFrequency :(double)freq;
- (int) getSamples :(short *)samples :(int)numSamples;
- (int) mixSamples :(short *)samples :(int)numSamples;

- (double) getSample;

@end
