//
//  Vco.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
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
    int modulationType;
    double rangeMultiplier;
    double detuneMultiplier;
    
}

@property int modulationType;


- (id)init;

- (void)setRange :(int)octave; 
- (void)setDetuneInCents :(int)cents;



@end
