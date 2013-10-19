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


- (void)onConnect;
- (void)onDisconnect;
@end


/*
 * constants for defining the leapmotion sensor zone 
 */
#define kLeftXMin -200
#define kLeftXMax -70

#define kLeftYMin 150
#define kLeftYMax 500

#define kLeftZMin 0
#define kLeftZMax 120

#define kRightXMin 70
#define kRightXMax 200

#define kRightYMin 150
#define kRightYMax 500

#define kRightZMin 0
#define kRightZMax 120


#define kDebounceTimeInSecs 0.250

@interface LeapSyntheremin : NSObject<LeapListener>
{
    LeapController *leapController;

    int32_t leftHandId;
    int32_t rightHandId;
    
    double leftTapDebounce;
    double rightTapDebounce;
    
}

@property (weak) id <LeapSynthereminDelegate> delegate;

- (id)init;


+ (LeapVector *)normalizePositionForLeftHand:(LeapVector *)position;
+ (LeapVector *)normalizePositionForRightHand:(LeapVector *)position;
@end
