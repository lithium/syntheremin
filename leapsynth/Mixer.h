//
//  Mixer.h
//  leapsynth
//
//  Created by Wiggins on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SampleProvider.h"

@interface Mixer : SampleProvider
{
    NSMutableArray *inputs;
}

- (id)init;

- (double)sampleAllInputs;

- (int)addInput:(SampleProvider*)source;
- (SampleProvider*)inputAtIndex:(int)index;
- (void)removeInput:(SampleProvider*)source;

@end
