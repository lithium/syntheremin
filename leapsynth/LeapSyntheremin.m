//
//  LeapSyntheremin.m
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "LeapSyntheremin.h"

@implementation LeapSyntheremin

@synthesize delegate;


- (id)init
{
    if (self) {
        self = [super init];
        
        leftHandId = rightHandId = -1;
        
        leapController = [[LeapController alloc] init];
        [leapController addListener:self];
        
    }
    
    return self;
}

- (void)onConnect:(NSNotification *)notification
{
    [leapController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [leapController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    
    if ([delegate respondsToSelector:@selector(onConnect)]) {
        [delegate onConnect];
    }

}

- (void)onDisconnect:(NSNotification *)notification
{
    if ([delegate respondsToSelector:@selector(onDisconnect)]) {
        [delegate onDisconnect];
    }
}


- (void)onFrame:(NSNotification *)notification
{
    LeapController *leap = (LeapController *)[notification object];
    LeapFrame *frame = [leap frame:0];
    bool leftFound,rightFound;
    
    leftFound = rightFound = false;
    
    if ([[frame hands] count] != 0) {
        for (LeapHand *hand in [frame hands]) {
            int32_t hand_id = [hand id];
            LeapVector *pos = [hand stabilizedPalmPosition];
            pos = [[frame interactionBox] normalizePoint:pos clamp:YES];

            if (hand_id != leftHandId && hand_id != rightHandId) {
                //unknown hand assign it.
                if ([pos x] < 0.5) {
                    leftHandId = hand_id;
                } else {
                    rightHandId = hand_id;
                }
            }
            
            int fingerCount = [[hand pointables] count];
            if (hand_id == leftHandId) {
                leftFound = true;

                LeapVector *normalPos = [LeapSyntheremin normalizePositionForLeftHand:pos];
                if ([delegate respondsToSelector:@selector(leftHandMotion::)]) {
                    [delegate leftHandMotion:hand :normalPos];
                        
                }
                
                if (leftHandOpen && fingerCount < 2) {
                    leftHandOpen = NO;
                    if ([delegate respondsToSelector:@selector(leftHandClosed:)]) 
                        [delegate leftHandClosed:hand];
                }
                else if (!leftHandOpen && fingerCount > 1) {
                    leftHandOpen = YES;
                    if ([delegate respondsToSelector:@selector(leftHandOpened:)])
                        [delegate leftHandOpened:hand];

                }
            }
            else if (hand_id == rightHandId) {
                rightFound = true;

                //track tip position for right hand
                pos = [[[hand pointables] frontmost] stabilizedTipPosition];
                pos = [[frame interactionBox] normalizePoint:pos clamp:YES];

                LeapVector *normalPos = [LeapSyntheremin normalizePositionForRightHand:pos];

                if ([delegate respondsToSelector:@selector(rightHandMotion::)]) {
                    [delegate rightHandMotion:hand :normalPos];
                }
                
                if (rightHandOpen && fingerCount < 2) {
                    rightHandOpen = NO;
                    if ([delegate respondsToSelector:@selector(rightHandClosed:)]) 
                        [delegate rightHandClosed:hand];
                }
                else if (!rightHandOpen && fingerCount > 1) {
                    rightHandOpen = YES;
                    if ([delegate respondsToSelector:@selector(rightHandOpened:)])
                        [delegate rightHandOpened:hand];
                }

            }
        }
    }
    
    
    if (leftHandId != -1 && !leftFound) {
        if ([delegate respondsToSelector:@selector(leftHandGone:)]) {
            [delegate leftHandGone:leftHandId];
        }
        leftHandId = -1;
    }
    if (rightHandId != -1 && !rightFound) {
        if ([delegate respondsToSelector:@selector(rightHandGone:)]) {
            [delegate rightHandGone:rightHandId];
        }
        rightHandId = -1;
    }

    
//    NSArray *gestures = [frame gestures:nil];
//    double now = CFAbsoluteTimeGetCurrent();
//    for (int i = 0; i < [gestures count]; i++) {
//        LeapGesture *gesture = [gestures objectAtIndex:i];
//        for (LeapHand *hand in [gesture hands]) {
//            int32_t hand_id = [hand id];
//            LeapVector *pos = [hand palmPosition];
//
//            if (hand_id != leftHandId && hand_id != rightHandId) {
//                if ([pos x] < 0) {
//                    leftHandId = hand_id;
//                    leftFound = true;
//                } else {
//                    rightHandId = hand_id;
//                    rightFound = true;
//                }
//            }
//            if (hand_id == leftHandId && (now-leftTapDebounce)>kDebounceTimeInSecs ) {
//                leftTapDebounce = now;
//                if ([delegate respondsToSelector:@selector(leftHandTap::)]) {
//                    [delegate leftHandTap:hand :gesture];
//                }
//                
//            }
//            else if (hand_id == rightHandId && (now-rightTapDebounce)>kDebounceTimeInSecs) {
//                rightTapDebounce = now;
//                if ([delegate respondsToSelector:@selector(rightHandTap::)]) {
//                    [delegate rightHandTap:hand :gesture];
//                }
//            }
//
//        }
//
//    }
}

// interactionBox gives us 0..1 for the entire sensor width
// we want to split it for left and right and with a bit 
// of dead space in center so hands dont overlap
// left hand normalizes to: 0.0 -> 0.4
//           right hand at: 0.6 -> 1.0
#define kLeftXMin 0.0
#define kLeftXMax 0.4
#define kLeftXRange kLeftXMax-kLeftXMin
#define kRightXMin 0.6
#define kRightXMax 1.0
#define kRightXRange kRightXMax-kRightXMin

+ (LeapVector *)normalizePositionForLeftHand:(LeapVector *)normalizedPosition
{
    double x = MAX(MIN(normalizedPosition.x, 0.4), 0);
    return [[LeapVector alloc] initWithX:x/0.4 y:normalizedPosition.y z:normalizedPosition.z];
}
+ (LeapVector *)normalizePositionForRightHand:(LeapVector *)normalizedPosition
{
    double x = MAX(MIN(normalizedPosition.x, 1.0), 0.6);
    return [[LeapVector alloc] initWithX:((x-0.6)/0.4) y:normalizedPosition.y z:normalizedPosition.z];    
}

@end
