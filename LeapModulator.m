//
//  LeapModulator.m
//  leapsynth
//
//  Created by Wiggins on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeapModulator.h"

@implementation LeapModulator
@synthesize inverted;

- (double)getSample
{
    return inverted ? 1.0 - level : level;
}
@end
