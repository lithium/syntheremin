//
//  Vca.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Adsr.h"

@interface Vca : Adsr

- (int) modifySamples :(short *)samples :(int)numSamples;

@end
