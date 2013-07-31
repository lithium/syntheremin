//
//  Vco.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

enum  {
    kWaveSquare=0,
    kWaveSine=1,
    kWaveSaw=2,
};

@interface Oscillator : NSObject {
    int waveShape;
    long samplesPerPeriod;
    long sampleStep;
}

@property int waveShape;

- (id) init;
- (void) setFrequency :(double)freq;
- (int) getSamples :(short *)samples :(int)numSamples;
- (double) getSample;

@end
