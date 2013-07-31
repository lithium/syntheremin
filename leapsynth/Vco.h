//
//  Vco.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oscillator.h"

enum {
    kCentsPerOctave = 1200,
    
    kCentsDetuneMin = 0,
    kCentsDetuneMax = kCentsPerOctave,

};

enum {
    kModulationTypeNone=0,
    kModulationTypeAmplitude,
    kModulationTypeFrequency,
};

@interface Vco : Oscillator {
    double frequency;
    Oscillator *lfo;
    int modulationType;
    double modulationDepth;
    double rangeMultiplier;
    double detuneMultiplier;
}

@property int modulationType;
@property double modulationDepth;
@property double rangeMultiplier;

- (id)init;

- (void)setDetuneInCents :(int)cents;
- (void)setLfoWaveshape :(int)waveShape;
- (void)setLfoFrequency :(double)frequency;


@end
