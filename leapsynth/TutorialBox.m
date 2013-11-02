//
//  TutorialBox.m
//  leapsynth
//
//  Created by Wiggins on 11/1/13.
//
//

#import "TutorialBox.h"

@implementation TutorialBox


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftMin = 1.0;
        _leftMax = 0.0;
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_tutorialStep == 3) {
        
    }
    else {
        [self nextStep];
    }
}
- (void)keyDown:(NSEvent *)theEvent
{
    [self nextStep];
}
-(void)rightHandMotion:(double)x :(double)y :(double)z
{
    if (_tutorialStep == 1)
    {
        _rightDone = YES;
    }
    else if (_tutorialStep == 2) {
        
        if (x < _rightMin)
            _rightMin = x;
        else if (x > _rightMax)
            _rightMax = x;
        
        if (_rightMin < 0.2 && _rightMax > 0.8)
            _rightDone = YES;
        
    }

    
    [self _checkLeftRightDone];
}
-(void)leftHandMotion:(double)x :(double)y :(double)z
{
    if (_tutorialStep == 1)
    {
        _leftDone = YES;
    }
    else if (_tutorialStep == 2) {
    
        if (y < _leftMin)
            _leftMin = y;
        else if (y > _leftMax)
            _leftMax = y;
        
        if (_leftMin < 0.2 && _leftMax > 0.8)
            _leftDone = YES;
        
    }
    
    [self _checkLeftRightDone];
}

- (void)_checkLeftRightDone
{
    if (_leftDone && _rightDone) {
        _leftDone = NO;
        _rightDone = NO;
        [self nextStep];
    }

}


- (void)nextStep
{
    NSView *content = [self superview];
    NSRect superBounds = [content frame];
    switch (++_tutorialStep) {
        case 1:
            [self setFrameOrigin:NSMakePoint(superBounds.size.width/2 - [self bounds].size.width/2,
                                             superBounds.size.height/2 - [self bounds].size.height/2)];
            break;
        case 2:
            [_tutorialText setTitleWithMnemonic:@"To play Syntheremin:\nMove your left palm up and down for volume, tuck your thumb.\nPoint with ONE finger on your right hand and move it side to side for pitch."];
            break;
            
        case 3:
            [self setFrameOrigin:NSMakePoint(50,600)];
            [_backgroundImage setFrame:NSMakeRect(0,0,275,55)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_showControls"]];
            [_tutorialText setTitleWithMnemonic:@"Click for synthesizer controls"];
            [_tutorialText setFrame:NSMakeRect(10,10,275,24)];
            break;
            
        case 4:
            [self setFrameOrigin:NSMakePoint(20,40)];
            [_backgroundImage setFrameSize:NSMakeSize(275,60)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_createPatches"]];
            [_tutorialText setTitleWithMnemonic:@"Tune to your favorite mode"];
            [_tutorialText setFrame:NSMakeRect(13,22,333,30)];
            break;

        default:
            [self tutorialComplete];
            break;
    }
}



- (void)tutorialComplete
{
    [self removeFromSuperview];
    if (_delegate) {
        [_delegate tutorialComplete];
    }
}
@end
