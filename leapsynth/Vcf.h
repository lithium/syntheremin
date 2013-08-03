//
//  Vcf.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Adsr.h"

@interface Vcf : Adsr


- (int) modifySamples :(short *)samples :(int)numSamples;

@end
