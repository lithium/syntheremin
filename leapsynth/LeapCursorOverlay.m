//
//  LeapCursorOverlay.m
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeapCursorOverlay.h"

@implementation LeapCursorOverlay

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftDotColor = [NSColor colorWithSRGBRed:48/255.0 green:176/255.0 blue:196/255.0 alpha:0.6];
        rightDotColor = [NSColor colorWithSRGBRed:195/255.0 green:50/255.0 blue:62/255.0 alpha:0.6];
        
        double sidePadding = [self bounds].size.width/10;
        double topPadding = [self bounds].size.height/10;
        cursorFrame = NSMakeRect(sidePadding, 
                                 topPadding, 
                                 [self bounds].size.width-sidePadding*2,
                                 [self bounds].size.height-topPadding*2);
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    NSRect bounds = [self bounds];
    
    [[NSColor blackColor] set];
    [[NSBezierPath bezierPathWithRect:cursorFrame] stroke];
    
    // draw left hand
    NSBezierPath *leftDotPath = [[NSBezierPath alloc] init];
    int left_radius = (leftHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
    int left_x = cursorFrame.origin.x + leftHand.x * (cursorFrame.size.width/2 - left_radius);
    int left_y = cursorFrame.origin.y + leftHand.y * (cursorFrame.size.height - left_radius);    
    [leftDotPath appendBezierPathWithOvalInRect:NSMakeRect(left_x,left_y,left_radius,left_radius)];
    [leftDotColor set];
    [leftDotPath fill];
    
    
    //draw right hand
    NSBezierPath *rightDotPath = [[NSBezierPath alloc] init];
    int right_radius = (rightHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
    int right_x = cursorFrame.origin.x + (rightHand.x * (cursorFrame.size.width/2 - right_radius)) + (cursorFrame.size.width/2);
    int right_y = cursorFrame.origin.y + rightHand.y * (cursorFrame.size.height-right_radius);    
    [rightDotPath appendBezierPathWithOvalInRect:NSMakeRect(right_x,right_y,right_radius,right_radius)];
    [rightDotColor set];
    [rightDotPath fill];
    
    [ctx restoreGraphicsState];

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
