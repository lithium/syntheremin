//
//  SynthAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SynthAnalyzer.h"

@implementation SynthAnalyzer


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];

    NSRect bounds = [self bounds];
    NSBezierPath *path = [[NSBezierPath alloc] init];

    
    [path moveToPoint:NSMakePoint(0,bounds.size.height/2)];
    
    float step = bounds.size.width/samplesInBuffer;
    int i;
    for (i=0; i < samplesInBuffer; i++) {
        short sample = buffer[i];
        float r = (float)(sample - SHRT_MIN)/(float)(SHRT_MAX-SHRT_MIN);
        float y = r * (float)bounds.size.height;
        [path lineToPoint:NSMakePoint(i*step,y)];
    }
    [path stroke];

    [ctx restoreGraphicsState];
}

- (void) receiveSamples :(short *)samples :(int)numSamples
{
    memcpy(buffer, samples, sizeof(short)*numSamples);
    samplesInBuffer = numSamples;
    [self setNeedsDisplay:true];
}

@end
