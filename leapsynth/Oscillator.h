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
    double currentFrequency;
}

@property int waveShape;


- (void) setFrequencyInHz:(double)frequencyInHz;
- (double) getFrequencyInHz;


- (double) getSample;
@end
