//
//  Vcf.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "SampleProvider.h"

#define kCutoffMin 20.0
#define kCutoffMax 8000.0

#define kDepthMin -2.0
#define kDepthMax 2.0


@interface Vcf : SampleProvider {
    double resonance, depth, cutoff, cutoffFrequencyInHz;

    double x, r, p, k, y1, y2, y3, y4, oldx, oldy1, oldy2, oldy3;
}


- (id)init;

- (void)setCutoffFrequencyInHz:(double)cutoff;
- (void)setResonance:(double)resonance;
- (void)setDepth:(double)depth;

- (int) getSamples:(short *)samples :(int)numSamples;

@end
