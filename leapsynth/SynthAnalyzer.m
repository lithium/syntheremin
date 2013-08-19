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
        buffer = [[NSMutableData alloc] initWithCapacity:2048*sizeof(short)];
        
        waveColor = [NSColor colorWithSRGBRed:0/255.0 green:34/255.0 blue:216/255.0 alpha:1.0];
        leftDotColor = [NSColor colorWithSRGBRed:48/255.0 green:176/255.0 blue:196/255.0 alpha:0.6];
        rightDotColor = [NSColor colorWithSRGBRed:195/255.0 green:50/255.0 blue:62/255.0 alpha:0.6];
        
        axisColor = [NSColor colorWithSRGBRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    NSRect bounds = [self bounds];
    
    [[NSColor blackColor] set];
    NSRectFill(bounds);
    
    // draw axis
    NSBezierPath *axisPath = [[NSBezierPath alloc] init];
    [axisPath setLineWidth:0.5];
    [axisColor set];
    [axisPath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
    [axisPath lineToPoint:NSMakePoint(bounds.size.width,bounds.size.height/2)];
    [axisPath moveToPoint:NSMakePoint(bounds.size.width/2,0)];
    [axisPath lineToPoint:NSMakePoint(bounds.size.width/2,bounds.size.height)];
    [axisPath stroke];


    // draw waveform
    NSBezierPath *wavePath = [[NSBezierPath alloc] init];
    [wavePath setLineWidth:3.0];
    [wavePath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
    
    float step = bounds.size.width/samplesInBuffer;
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
    
    
    // draw left hand
    NSBezierPath *leftDotPath = [[NSBezierPath alloc] init];
    int left_radius = (leftHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
    int left_x = leftHand.x * ((bounds.size.width/2)-left_radius);
    int left_y = leftHand.y * (bounds.size.height-left_radius);    
    [leftDotPath appendBezierPathWithOvalInRect:NSMakeRect(left_x,left_y,left_radius,left_radius)];
    [leftDotColor set];
    [leftDotPath fill];
    
    
    //draw right hand
    NSBezierPath *rightDotPath = [[NSBezierPath alloc] init];
    int right_radius = (rightHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
    int right_x = (rightHand.x * (bounds.size.width/2 - right_radius)) + (bounds.size.width/2);
    int right_y = rightHand.y * (bounds.size.height-right_radius);    
    [rightDotPath appendBezierPathWithOvalInRect:NSMakeRect(right_x,right_y,right_radius,right_radius)];
    [rightDotColor set];
    [rightDotPath fill];

    [ctx restoreGraphicsState];
    
}

- (void) receiveSamples :(short *)samples :(int)numSamples
{
    [buffer replaceBytesInRange:NSMakeRange(0,numSamples*sizeof(short)) withBytes:samples];
    samplesInBuffer = numSamples;
    [self setNeedsDisplay:true];
}

- (void) setLeftHand:(CGFloat)x :(CGFloat)y :(CGFloat)z
{
    leftHand.x = x;
    leftHand.y = y;
    leftHand.z = z;
}
- (void) setRightHand:(CGFloat)x :(CGFloat)y :(CGFloat)z
{
    rightHand.x = x;
    rightHand.y = y;
    rightHand.z = z;
}

@end
