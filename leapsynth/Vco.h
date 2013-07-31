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
    kWaveSquare,
    kWaveSine,
    kWaveSaw
};

@interface Vco : NSObject {
    int waveShape;
    long samplesPerPeriod;
    long sampleStep;
}

@property int waveShape;

- (void) setFrequency :(int)freq;
- (int) getSamples :(short *)samples :(int)numSamples;

@end
