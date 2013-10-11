//
//  Vca.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Adsr.h"

@interface Vca : Adsr
{
    double masterVolume;
}

@property double masterVolume;

- (int) modifySamples :(short *)samples :(int)numSamples;

@end
