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
        _rightMin = 1.0;
        _rightMax = 0.0;
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self nextStep];
}
- (void)keyDown:(NSEvent *)theEvent
{
    char key = [[theEvent characters] characterAtIndex:0];
    if (key == '\e') {
        [self tutorialComplete];
        return;
    }
    
    
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

-(void)switchToSynth
{
    if (_tutorialStep == 3) {
        [self nextStep];
    }

}
-(void)switchToTheremin
{
    if (_tutorialStep == 4) {
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
            
            [self setFrameSize:NSMakeSize(389,169)];
            [_backgroundImage setFrame:NSMakeRect(0,0,389,169)];

            [_tutorialText setTitleWithMnemonic:@"To play Syntheremin:\nCup your left hand and move it up and down for volume.\n\nPoint with ONE finger on your right hand and move it left to right for pitch."];
            [_tutorialText setFrame:NSMakeRect(10,10,359,149)];

            break;
            
        case 3:
            [self setFrame:NSMakeRect(50,620,275,55)];
            [_backgroundImage setFrame:NSMakeRect(0,0,275,55)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_showControls"]];
            [_tutorialText setTitleWithMnemonic:@"Click for synthesizer controls"];
            [_tutorialText setFrame:NSMakeRect(10,10,250,24)];
            break;
            
        case 4:
            if (_delegate && [_delegate respondsToSelector:@selector(switchToSynth:)]) {
                [_delegate switchToSynth:self];
            }

            [self setFrame:NSMakeRect(360,460,315,60)];
            [_backgroundImage setFrame:NSMakeRect(0,0,315,60)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_createPatches"]];
            [_tutorialText setTitleWithMnemonic:@"Drag endpoints to create Patches"];
            [_tutorialText setFrame:NSMakeRect(13,0,315,31)];
            break;

        case 5:
            if (_delegate && [_delegate respondsToSelector:@selector(switchToTheremin:)]) {
                [_delegate switchToTheremin:self];
            }

            [self setFrame:NSMakeRect(120,60,275,60)];
            [_backgroundImage setFrame:NSMakeRect(0,0,275,60)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_createPatches"]];
            [_tutorialText setTitleWithMnemonic:@"Play in your favorite mode"];
            [_tutorialText setFrame:NSMakeRect(13,25,250,30)];
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
