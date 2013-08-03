//
//  Synth.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vco.h"
#import "Vca.h"

@interface Synth : NSObject {
    Vco *vco;
    Vca *vca;
}

@property Vco *vco;
@property Vca *vca;


- (id)init;
- (int) getSamples :(short *)samples :(int)numSamples;


@end
