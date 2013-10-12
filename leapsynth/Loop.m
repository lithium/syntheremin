//
//  Loop.m
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Loop.h"



@implementation SampleChunk
- (id)init
{   
    if (self) {
        size = 0;
    }
    
    return self;
}
- (int)writeSamples:(short *)samples :(int)num_samples
{
    int avail = kChunkSize - size;
    int written = 0;
    if (samples && avail > 0 && num_samples > 0) {
        written = MIN(num_samples, avail);
        memcpy(buffer+size, samples, written*sizeof(short));
        size += written;
    }
    return written;    
}

@end


@implementation Loop
- (id)init
{
    if (self) {
        sampleChunks = [[NSMutableArray alloc] init];
        
        SampleChunk *chunk = [[SampleChunk alloc] init];
        [sampleChunks addObject:chunk];
        size = 0;
    }
    return self;
}

- (int)writeSamples:(short *)samples :(int)num_samples
{
    SampleChunk *chunk = [sampleChunks lastObject];
    int written = [chunk writeSamples:samples :num_samples];
    while (num_samples - written > 0) {       
        SampleChunk *newChunk = [[SampleChunk alloc] init];
        written += [newChunk writeSamples:samples+written :num_samples-written];
        [sampleChunks addObject:newChunk];
    }
    size += written;
    return written;
}

- (void)start
{
    playbackPosition = 0;
}
- (int)fillPlaybackBuffer:(short *)buffer :(int)num_samples
{
    int ofs = playbackPosition % kChunkSize;
    int idx = floor(playbackPosition / kChunkSize);
    int written = 0;
    
    // get the currently playing chunk
    SampleChunk *chunk = [sampleChunks objectAtIndex:idx];
    
    // play as much of the chunk as we can
    int chunk_size = MIN(chunk->size - ofs, num_samples); 

    memcpy(buffer, chunk->buffer+ofs, chunk_size*sizeof(short));
    written += chunk_size;
    
    while (num_samples - written > 0) {
        idx += 1;
        if (idx >= [sampleChunks count])
            idx = 0;
        SampleChunk *nextChunk = [sampleChunks objectAtIndex:idx];
        chunk_size = MIN(nextChunk->size, num_samples-written); 
        
        memcpy(buffer+written, nextChunk->buffer, chunk_size*sizeof(short));
        written += chunk_size;
    }
           
    playbackPosition += written;
    if (playbackPosition > size)
        playbackPosition = 0;
    
    return written;
}
-(int)size {
    return size;
}
@end
