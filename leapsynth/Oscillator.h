//
//  Vco.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import "SampleProvider.h"

enum  {
    kWaveSquare=0,
    kWaveSine=1,
    kWaveSaw=2,
    kWaveTriangle=3,
};

@interface Oscillator : SampleProvider {
    int waveShape;
    long samplesPerPeriod;
    long sampleStep;
}

@property int waveShape;

- (id) init;
- (void) setFrequency :(double)freq;
- (double) getSample;

@end
