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
            LeapVector *pos = [[frame interactionBox] normalizePoint:[hand stabilizedPalmPosition] 
                                                               clamp:YES];

            if (hand_id != leftHandId && hand_id != rightHandId) {
                //unknown hand assign it.
                if ([pos x] < 0.5) {
                    leftHandId = hand_id;
                    leftFound = true;
                } else {
                    rightHandId = hand_id;
                    rightFound = true;
                }
            }
            
            int fingerCount = [[hand pointables] count];
            if (hand_id == leftHandId) {
                if ([delegate respondsToSelector:@selector(leftHandMotion::)]) {
                    [delegate leftHandMotion:hand :pos];
                        
                }
                
                if (leftHandOpen && fingerCount < 2) {
                    leftHandOpen = NO;
                    if ([delegate respondsToSelector:@selector(leftHandClosed:)]) 
                        [delegate leftHandClosed:hand];
//                    NSLog(@"left hand closed");
                }
                else if (!leftHandOpen && fingerCount > 1) {
                    leftHandOpen = YES;
                    if ([delegate respondsToSelector:@selector(leftHandOpened:)])
                        [delegate leftHandOpened:hand];
//                    NSLog(@"left hand opened %d", fingerCount);

                }
            }
            else if (hand_id == rightHandId) {
                if ([delegate respondsToSelector:@selector(rightHandMotion::)]) {
                    [delegate rightHandMotion:hand :pos];
                }
                if (rightHandOpen && fingerCount < 2) {
                    rightHandOpen = NO;
                    if ([delegate respondsToSelector:@selector(rightHandClosed:)]) 
                        [delegate rightHandClosed:hand];
                    //                    NSLog(@"right hand closed");
                }
                else if (!rightHandOpen && fingerCount > 1) {
                    rightHandOpen = YES;
                    if ([delegate respondsToSelector:@selector(rightHandOpened:)])
                        [delegate rightHandOpened:hand];
                    //                    NSLog(@"right hand opened %d", fingerCount);
                    
                }

            }
        }
    }
    
    
//    if (leftHandId != -1 && !leftFound) {
//        if ([delegate respondsToSelector:@selector(leftHandGone:)]) {
//            [delegate leftHandGone:leftHandId];
//        }
//        leftHandId = -1;
//    }
//    if (rightHandId != -1 && !rightFound) {
//        if ([delegate respondsToSelector:@selector(rightHandGone:)]) {
//            [delegate rightHandGone:rightHandId];
//        }
//        rightHandId = -1;
//    }

    
//    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld, gestures: %ld",
//          [frame id], [frame timestamp], [[frame hands] count],
//          [[frame fingers] count], [[frame tools] count], [[frame gestures:nil] count]);

    
    NSArray *gestures = [frame gestures:nil];
    double now = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < [gestures count]; i++) {
        LeapGesture *gesture = [gestures objectAtIndex:i];
        for (LeapHand *hand in [gesture hands]) {
            int32_t hand_id = [hand id];
            LeapVector *pos = [hand palmPosition];

            if (hand_id != leftHandId && hand_id != rightHandId) {
                if ([pos x] < 0) {
                    leftHandId = hand_id;
                    leftFound = true;
                } else {
                    rightHandId = hand_id;
                    rightFound = true;
                }
            }
            if (hand_id == leftHandId && (now-leftTapDebounce)>kDebounceTimeInSecs ) {
                leftTapDebounce = now;
                if ([delegate respondsToSelector:@selector(leftHandTap::)]) {
                    [delegate leftHandTap:hand :gesture];
                }
                
            }
            else if (hand_id == rightHandId && (now-rightTapDebounce)>kDebounceTimeInSecs) {
                rightTapDebounce = now;
                if ([delegate respondsToSelector:@selector(rightHandTap::)]) {
                    [delegate rightHandTap:hand :gesture];
                }
            }

        }

    }
}

@end
