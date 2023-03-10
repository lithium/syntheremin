//
//  Vcf.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vcf.h"
#import "Defines.h"

@implementation Vcf

- (id)init
{
    if (self) {
        self = [super init];
        
        depth = 1.0;
    }
    return self;
}
- (void)setCutoffFrequencyInHz:(double)cutoffInHz
{
    cutoffFrequencyInHz  = MAX(MIN(cutoffInHz, kCutoffMax), kCutoffMin);
    cutoff = cutoffFrequencyInHz;

    [self recalculate];
}
- (void)setResonance:(double)value
{
    resonance = value;
    [self recalculate];
}

- (void)setDepth:(double)value
{
    depth = value;
}


- (void)recalculate 
{
    double f = (cutoff + cutoff) / (double)kSampleRate;
    p = f * (1.8 - (0.8 * f));
    k = p + p - 1.0;
    
    double t = (1.0 - p) * 1.386249;
    double t2 = 12.0 + t * t;
    r = resonance * (t2 + 6.0 * t) / (t2 - 6.0 * t);
}

- (short)processSample:(short)input
{
    // Process input
    x = ((double) input/SHRT_MAX) - r*y4;
    
    // Four cascaded one pole filters (bilinear transform)
    y1 =  x*p +  oldx*p - k*y1;
    y2 = y1*p + oldy1*p - k*y2;
    y3 = y2*p + oldy2*p - k*y3;
    y4 = y3*p + oldy3*p - k*y4;
    
    // Clipper band limited sigmoid
    y4 -= (y4*y4*y4) / 6.0;
    
    oldx = x; oldy1 = y1; oldy2 = y2; oldy3 = y3;
    return (short) (y4 * SHRT_MAX);
}

- (double)getSample
{
    double ds = [self sampleAllInputs];
    short sample = (short)(ds * SHRT_MAX);
    cutoff = cutoffFrequencyInHz;
    if (modulator) {
        cutoff *= pow(2.0, depth*[self getModulationSample]);
    }    
    [self recalculate];
    short newSample = [self processSample:sample];
    return ((double)newSample / SHRT_MAX);
}
- (void)updatePropertyList:(NSMutableDictionary*)props
{
    [super updatePropertyList:props];
    [props setObject:[NSNumber numberWithDouble:depth] forKey:@"depth"];
    [props setObject:[NSNumber numberWithDouble:resonance] forKey:@"resonance"];
    [props setObject:[NSNumber numberWithDouble:cutoffFrequencyInHz] forKey:@"cutoffFrequencyInHz"];
}

@end
