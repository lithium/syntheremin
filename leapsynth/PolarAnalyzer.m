//
//  PolarAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PolarAnalyzer.h"

@implementation Waveform
@synthesize minRadius;

- (id)initWithBounds:(NSRect)frame
{
    if (self)
    {
        buffer = [[NSMutableData alloc] initWithCapacity:2048*sizeof(short)];
        [self setBounds:frame];
        minRadius = 5;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone 
{
    Waveform *newWaveform = [Waveform allocWithZone:zone];
    newWaveform->buffer = [buffer copyWithZone:zone];
    newWaveform->samplesInBuffer = samplesInBuffer;
    newWaveform->minRadius = minRadius;
    newWaveform->maxRadius = maxRadius;
    newWaveform->bounds = bounds;
    return newWaveform;
}


- (NSRect)bounds { return bounds; }
- (void)setBounds:(NSRect)newBounds
{
    maxRadius = newBounds.size.height/3;
    bounds = newBounds;
}
- (NSBezierPath *)bezierPath
{
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path setLineWidth:3.0];
    
    NSPoint center = NSMakePoint(bounds.size.width/2, bounds.size.height/2);
    short *samples = (short*)[buffer bytes];
    double step = (2*M_PI)/samplesInBuffer;
    for (int i=0; i < samplesInBuffer; i++) {
        short sample = samples[i];
        double normal = (double)(sample-SHRT_MIN)/(double)(SHRT_MAX-SHRT_MIN);
        double phi = i*step;
        double r = baseRadius + normal*(maxRadius-minRadius)+minRadius;
        NSPoint point = NSMakePoint(center.x + r*cos(phi), center.y + r*sin(phi));
        if (i==0) {
            [path moveToPoint:point];
        } else {
            [path lineToPoint:point];
        }
    }
    [path closePath];
    return path;
}


@end


@implementation PolarAnalyzer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ripples = [[NSMutableArray alloc] initWithCapacity:1];
        [ripples addObject:[[Waveform alloc] initWithBounds:[self bounds]]];

        waveColor = [NSColor colorWithSRGBRed:255/255.0 green:160/255.0 blue:0/255.0 alpha:1.0];

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];

    int i=0;
    for (Waveform *ripple in ripples) 
    {
        NSBezierPath *path = [ripple bezierPath];
        double alpha = 1.0 - (ripple->baseRadius+ripple->minRadius) / (ripple->bounds.size.width/4);
        [[waveColor colorWithAlphaComponent:alpha] set];
        [path stroke];
        if (i++ > 0) {
            ripple->baseRadius += 2+5*alpha;
        }
    }
        
    [ctx restoreGraphicsState];

}



- (void) receiveSamples :(short *)samples :(int)numSamples
{
    Waveform *firstRipple = [ripples objectAtIndex:0];
    [firstRipple->buffer replaceBytesInRange:NSMakeRange(0,numSamples*sizeof(short)) withBytes:samples];
    firstRipple->samplesInBuffer = numSamples;
    [self setNeedsDisplay:true];
}

- (void)shedRipple
{    
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (now - lastRippleTime < kMinSecondsBetweenRipples) {
        return;
    }
    lastRippleTime = now;

    Waveform *newRipple = [[ripples objectAtIndex:0] copy];
    [ripples addObject:newRipple];
    if ([ripples count] > kMaxRipples) {
        [ripples removeObjectAtIndex:1];
    }
}
@end
