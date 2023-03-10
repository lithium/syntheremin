//
//  LeapCursorOverlay.m
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeapCursorOverlay.h"

@implementation LeapCursorOverlay
{
    double sidePadding,topPadding;
    double offset;
}
@synthesize drawGrid;
@synthesize leftHandVisible;
@synthesize rightHandVisible;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftDotColor = [NSColor colorWithSRGBRed:48/255.0 green:176/255.0 blue:196/255.0 alpha:0.6];
        rightDotColor = [NSColor colorWithSRGBRed:195/255.0 green:50/255.0 blue:62/255.0 alpha:0.6];
        gridColor = [NSColor colorWithSRGBRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1.0];

        
        offset = 13;
        sidePadding = 23;//[self bounds].size.width/10;
        topPadding = 23;//[self bounds].size.height/10;
        cursorFrame = NSMakeRect(13,
                                 topPadding, 
                                 [self bounds].size.width-13-23,
                                 [self bounds].size.height-topPadding*2);
        
        [self setLeftHandVisible:YES];
        [self setRightHandVisible:YES];
    }
    
    return self;
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    cursorFrame = NSMakeRect(13,
                             topPadding,
                             [self bounds].size.width-13-23,
                             [self bounds].size.height-topPadding*2);

}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
//    [[NSColor blackColor] set];
//    [[NSBezierPath bezierPathWithRect:cursorFrame] stroke];
    if ([self drawGrid]) {
        NSBezierPath *gridPath = [[NSBezierPath alloc] init];
        double step = cursorFrame.size.width/2 / 8;
        double x;
        double y;
        for (x=cursorFrame.origin.x+step + cursorFrame.size.width/2; x < cursorFrame.origin.x+cursorFrame.size.width; x += step) {
            [gridPath moveToPoint:NSMakePoint(x,cursorFrame.origin.y)];
            [gridPath lineToPoint:NSMakePoint(x,cursorFrame.origin.y+cursorFrame.size.height)];
        }
        
        x = cursorFrame.origin.x + cursorFrame.size.width/2;
        step = round(cursorFrame.size.height / 4);
        for (y=cursorFrame.origin.y+step; y < cursorFrame.origin.y+cursorFrame.size.height; y += step) {
            [gridPath moveToPoint:NSMakePoint(x+6,y)];
            [gridPath lineToPoint:NSMakePoint(x+cursorFrame.size.width/2,y)];
        }
        
        [gridColor set];
        [gridPath stroke];
    }

    // draw left hand
    if (leftHandVisible) {
        
        NSBezierPath *leftDotPath = [[NSBezierPath alloc] init];
        int left_radius = 25; //(leftHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
        int left_x = cursorFrame.origin.x + leftHand.x * (cursorFrame.size.width/2 - left_radius);
        int left_y = cursorFrame.origin.y + leftHand.y * (cursorFrame.size.height - left_radius);    
        [leftDotPath appendBezierPathWithOvalInRect:NSMakeRect(left_x,left_y,left_radius,left_radius)];
        
        left_y += left_radius/2;
        left_x += left_radius/2;
        [leftDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x, left_y)];
        [leftDotPath lineToPoint:NSMakePoint(left_x-left_radius/2, left_y)];
        [leftDotPath moveToPoint:NSMakePoint(left_x+left_radius/2, left_y)];
        [leftDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+3, left_y)];
        
        //left hash
        [leftDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x, left_y-7)];
        [leftDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x, left_y+7)];
        //right hash
        [leftDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+3, left_y-7)];
        [leftDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+3, left_y+7)];

        
        
        [leftDotColor set];
        [leftDotPath stroke];
        [[leftDotColor colorWithAlphaComponent:0.4] set];
        [leftDotPath fill];
    }

    
    
    //draw right hand
    if (rightHandVisible) {
        NSBezierPath *rightDotPath = [[NSBezierPath alloc] init];
        int right_radius = 25; //(rightHand.z * (kHandRadiusMax - kHandRadiusMin)) + kHandRadiusMin;
        int right_x = cursorFrame.origin.x + (rightHand.x * (cursorFrame.size.width/2 - right_radius - 6 - 6)) + (cursorFrame.size.width/2)+6+3;
        int right_y = cursorFrame.origin.y + rightHand.y * (cursorFrame.size.height-right_radius);    
        [rightDotPath appendBezierPathWithOvalInRect:NSMakeRect(right_x,right_y,right_radius,right_radius)];
        
        right_y += right_radius/2;
        right_x += right_radius/2;
        [rightDotPath moveToPoint:NSMakePoint(right_x, cursorFrame.origin.y+2)];
        [rightDotPath lineToPoint:NSMakePoint(right_x, right_y-right_radius/2)];
        [rightDotPath moveToPoint:NSMakePoint(right_x, right_y+right_radius/2)];
        [rightDotPath lineToPoint:NSMakePoint(right_x, cursorFrame.origin.y+cursorFrame.size.height-2)];

        //top hash
        [rightDotPath moveToPoint:NSMakePoint(right_x-7, cursorFrame.origin.y+cursorFrame.size.height-2)];
        [rightDotPath lineToPoint:NSMakePoint(right_x+7, cursorFrame.origin.y+cursorFrame.size.height-2)];
        //bottom hash
        [rightDotPath moveToPoint:NSMakePoint(right_x-7, cursorFrame.origin.y+2)];
        [rightDotPath lineToPoint:NSMakePoint(right_x+7, cursorFrame.origin.y+2)];


        if ([self drawGrid]) {
            [rightDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+6+2, right_y)];
            [rightDotPath lineToPoint:NSMakePoint(right_x-right_radius/2, right_y)];
            [rightDotPath moveToPoint:NSMakePoint(right_x+right_radius/2, right_y)];
            [rightDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width-2, right_y)];
            
            //left hash
            [rightDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+6+2, right_y-7)];
            [rightDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width/2+6+2, right_y+7)];
            //right hash
            [rightDotPath moveToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width-2, right_y-7)];
            [rightDotPath lineToPoint:NSMakePoint(cursorFrame.origin.x+cursorFrame.size.width-2, right_y+7)];


        }
        [rightDotColor set];
        [rightDotPath stroke];
        [[rightDotColor colorWithAlphaComponent:0.4] set];

        [rightDotPath fill];
    }


    
    [ctx restoreGraphicsState];

}

- (void) setLeftHand:(CGFloat)x :(CGFloat)y :(CGFloat)z
{
    leftHand.x = x;
    leftHand.y = y;
    leftHand.z = z;
        [self setNeedsDisplay:YES];
}
- (void) setRightHand:(CGFloat)x :(CGFloat)y :(CGFloat)z
{
    rightHand.x = x;
    rightHand.y = y;
    rightHand.z = z;
    [self setNeedsDisplay:YES];
}

@end
