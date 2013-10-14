//
//  Vca.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleProvider.h"

@interface Vca : SampleProvider
{
    NSMutableArray *inputs;
}

- (id)init;

- (double) getSample;

- (int)addInput:(SampleProvider*)source;
- (SampleProvider*)inputAtIndex:(int)index;

@end
