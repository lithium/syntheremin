//
//  Mixer.m
//  leapsynth
//
//  Created by Wiggins on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Mixer.h"

@implementation Mixer

- (double) getSample
{
    return [self getModulationSample]*level;
}
@end
