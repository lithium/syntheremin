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

@interface Vco : Oscillator {
    double rangeMultiplier;
    double detuneMultiplier;
    
}



- (id)init;

- (void)setRange :(int)octave; 
- (void)setDetuneInCents :(int)cents;



@end
