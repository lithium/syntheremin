//
//  Loop.h
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kChunkSize 4096

@interface SampleChunk : NSObject
{
@public
    short buffer[kChunkSize];
    int size; // <= kChunkSize
}
- (id)init;
- (int)writeSamples:(short *)samples :(int)num_samples;
@end


@interface Loop : NSObject
{
    NSMutableArray *sampleChunks; 
    int size; // number of samples across all chunks 
    
    int playbackPosition;
}
- (id)init;

- (int)writeSamples:(short *)samples :(int)num_samples;

- (void)start;
- (int)fillPlaybackBuffer:(short *)buffer :(int)num_samples;


@end
