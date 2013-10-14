//
//  Vca.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vca.h"

@implementation Vca

- (double) getSample
{
    return [self sampleAllInputs]*[self getModulationSample];
}

@end
