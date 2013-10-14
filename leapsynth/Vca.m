//
//  Vca.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vca.h"

@implementation Vca

- (id) init
{
    if (self) {
        self = [super init];
        inputs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (double) getSample
{
    //average all inputs
    double sample = 0;
    for (id source in inputs) {
        sample += [source getSample];
    }
    sample /= [inputs count];
    
    double m = 1.0 - ([self getModulationSample] + 1.0) / 2.0;
    return sample*m;
}

- (int)addInput:(SampleProvider*)source
{
    [inputs addObject:source];
    return [inputs indexOfObject:source];
}
- (SampleProvider*)inputAtIndex:(int)index
{
    return [inputs objectAtIndex:index];
}


@end
