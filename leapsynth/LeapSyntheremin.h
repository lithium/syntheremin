//
//  LeapSyntheremin.h
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@protocol LeapSynthereminDelegate <NSObject>
- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)normal;
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)normal;

//    - (void)leftHandGone:(int32_t)hand_id;
//    - (void)rightHandGone:(int32_t)hand_id;

- (void)leftHandTap:(LeapHand *)hand :(LeapGesture *)gesture;
- (void)rightHandTap:(LeapHand *)hand :(LeapGesture *)gesture;

- (void)leftHandOpened:(LeapHand *)hand;
- (void)leftHandClosed:(LeapHand *)hand;
- (void)rightHandOpened:(LeapHand *)hand;
- (void)rightHandClosed:(LeapHand *)hand;


- (void)onConnect;
- (void)onDisconnect;
@end


#define kDebounceTimeInSecs 0.250

@interface LeapSyntheremin : NSObject<LeapListener>
{
    LeapController *leapController;

    int32_t leftHandId;
    int32_t rightHandId;
    
    double leftTapDebounce;
    double rightTapDebounce;
    
    
    BOOL leftHandOpen, rightHandOpen;

}

@property (weak) id <LeapSynthereminDelegate> delegate;

- (id)init;


+ (LeapVector *)normalizePositionForLeftHand:(LeapVector *)normalizedPosition;
+ (LeapVector *)normalizePositionForRightHand:(LeapVector *)normalizedPosition;
@end
