//
//  PolarAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PolarAnalyzer.h"

@implementation PolarAnalyzer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buffer = [[NSMutableData alloc] initWithCapacity:2048*sizeof(short)];

        waveColor = [NSColor colorWithSRGBRed:0/255.0 green:34/255.0 blue:216/255.0 alpha:1.0];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    NSRect bounds = [self bounds];

    
    [ctx saveGraphicsState];
    
    NSBezierPath *wavePath = [[NSBezierPath alloc] init];
    [wavePath setLineWidth:3.0];
    
    short *samples = (short*)[buffer bytes];
    double step = (2*M_PI)/samplesInBuffer;
    double radius = bounds.size.width/3;
    
    NSPoint center = NSMakePoint(bounds.size.width/2, bounds.size.height/2);
    for (int i=0; i < samplesInBuffer; i++) {
        short sample = samples[i];
        double normal = (double)(sample-SHRT_MIN)/(double)(SHRT_MAX-SHRT_MIN);
        
        //polar coordinates
        double phi = i*step;
        double r = normal*radius;
        
        //translate to cartesian
        NSPoint point = NSMakePoint(center.x + r*cos(phi), center.y + r*sin(phi));
        
        if (i==0) {
            [wavePath moveToPoint:point];
        } else {
            [wavePath lineToPoint:point];
        }
    }
    [wavePath closePath];
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
