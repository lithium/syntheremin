//
//  Mixer.m
//  leapsynth
//
//  Created by Wiggins on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Mixer.h"

@implementation Mixer

- (id) init
{
    if (self) {
        self = [super init];
        inputs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (double)sampleAllInputs
{
    double sample = 0;
    for (id source in inputs) {
        sample += [source getSample];
    }
    sample /= [inputs count];
    
    return sample;
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
- (void)removeInput:(SampleProvider*)source
{
    [inputs removeObject:source];
}

@end
