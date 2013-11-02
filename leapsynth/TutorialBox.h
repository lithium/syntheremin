//
//  TutorialBox.h
//  leapsynth
//
//  Created by Wiggins on 11/1/13.
//
//

#import <Cocoa/Cocoa.h>

@protocol TutorialDelegate <NSObject>

-(void)tutorialComplete;

@end

@interface TutorialBox : NSBox
{
    double _leftMin,_leftMax;
    double _rightMin,_rightMax;
    
    BOOL _leftDone,_rightDone;
}

@property (weak) id  <TutorialDelegate> delegate;
@property int tutorialStep;
@property (weak) IBOutlet NSTextField *tutorialText;
@property (weak) IBOutlet NSImageView *backgroundImage;

- (void)nextStep;
-(void)rightHandMotion:(double)x :(double)y :(double)z;
-(void)leftHandMotion:(double)x :(double)y :(double)z;

-(void)switchToSynth;
-(void)switchToTheremin;
@end
