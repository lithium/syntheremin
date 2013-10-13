//
//  SampleProvider.h
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleProvider : NSObject 
{
    double level;
}
@property double level;


- (id) init;

- (int) getSamples :(short *)samples :(int)numSamples;
- (int) mixSamples :(short *)samples :(int)numSamples;
- (double) getSample;

@end
