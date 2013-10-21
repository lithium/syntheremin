//
//  SynthAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "SynthAnalyzer.h"

@implementation SynthAnalyzer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        buffer = [[NSMutableData alloc] initWithCapacity:2048*sizeof(short)];
        
        waveColor = [NSColor colorWithSRGBRed:0/255.0 green:34/255.0 blue:216/255.0 alpha:1.0];
        majorAxisColor = [NSColor colorWithSRGBRed:0.8 green:0.8 blue:0.8 alpha:1];
        minorAxisColor = [NSColor colorWithSRGBRed:0 green:1 blue:0 alpha:0.5];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    NSRect bounds = [self bounds];
    
//    [[NSColor blackColor] set];
//    NSRectFill(bounds);
    
    // draw axis
    NSBezierPath *minorAxisPath = [[NSBezierPath alloc] init];
    [minorAxisPath setLineWidth:0.2];

    NSBezierPath *majorAxisPath = [[NSBezierPath alloc] init];
    [majorAxisPath setLineWidth:0.5];

    
    // draw minor axis ticks

    int numTicks = 12;
    double step = (bounds.size.height/2) / numTicks;
    double j;
    
    for (j=0; j < bounds.size.height; j += step) {
        [minorAxisPath moveToPoint:NSMakePoint(0,j)];
        [minorAxisPath lineToPoint:NSMakePoint(bounds.size.width,j)];
        
    }
    step = (bounds.size.width/2) / numTicks;
    for (j=0; j < bounds.size.width; j += step) {
        [minorAxisPath moveToPoint:NSMakePoint(j,0)];
        [minorAxisPath lineToPoint:NSMakePoint(j,bounds.size.height)];
    }
    [minorAxisColor set];
    [minorAxisPath stroke];

    // draw major axis
    [majorAxisPath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
    [majorAxisPath lineToPoint:NSMakePoint(bounds.size.width,bounds.size.height/2)];
    [majorAxisPath moveToPoint:NSMakePoint(bounds.size.width/2,0)];
    [majorAxisPath lineToPoint:NSMakePoint(bounds.size.width/2,bounds.size.height)];
    [majorAxisColor set];
    [majorAxisPath stroke];


    // draw waveform
    NSBezierPath *wavePath = [[NSBezierPath alloc] init];
    [wavePath setLineWidth:3.0];
    [wavePath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
    
    step = bounds.size.width/samplesInBuffer;
    int i;
    short *samples = (short*)[buffer bytes];
    for (i=0; i < samplesInBuffer; i++) {
        short sample = samples[i];
        float r = (float)(sample - SHRT_MIN)/(float)(SHRT_MAX-SHRT_MIN);
        float y = r * (float)bounds.size.height;
        [wavePath lineToPoint:NSMakePoint(i*step,y)];
    }
    [waveColor set];
    [wavePath stroke];
    
    [ctx restoreGraphicsState];
    
}

- (void) receiveSamples :(short *)samples :(int)numSamples
{
    [buffer replaceBytesInRange:NSMakeRange(0,numSamples*sizeof(short)) withBytes:samples];
    samplesInBuffer = numSamples;
    [self setNeedsDisplay:true];
}


@end
