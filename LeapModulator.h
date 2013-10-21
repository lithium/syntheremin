//
//  LeapModulator.h
//  leapsynth
//
//  Created by Wiggins on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SampleProvider.h"
#import "Synth.h"


@interface LeapModulator : SampleProvider
{
    BOOL inverted;
}
@property BOOL inverted;

- (double)getSample;
@end
