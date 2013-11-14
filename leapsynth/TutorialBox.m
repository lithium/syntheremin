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
            [self setFrameSize:NSMakeSize(496,305)];
            [self setFrameOrigin:NSMakePoint(superBounds.size.width/2 - [self bounds].size.width/2,
                                             superBounds.size.height/2 - [self bounds].size.height/2)];
            
            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-1"]];
            break;
            
        case 2:
            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-2"]];
            break;
            
        case 3:
            [self setFrame:NSMakeRect(50,620,397,70)];
            [_backgroundImage setFrame:NSMakeRect(0,0,397,70)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-controls"]];
            break;
            
        case 4:
            if (_delegate && [_delegate respondsToSelector:@selector(switchToSynth:)]) {
                [_delegate switchToSynth:self];
            }

            [self setFrame:NSMakeRect(360,460,347,70)];
            [_backgroundImage setFrame:NSMakeRect(0,0,347,70)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-patches"]];
            break;

        case 5:
            if (_delegate && [_delegate respondsToSelector:@selector(switchToTheremin:)]) {
                [_delegate switchToTheremin:self];
            }

            [self setFrame:NSMakeRect(120,60,278,67)];
            [_backgroundImage setFrame:NSMakeRect(0,0,278,67)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-mode"]];
            break;

        default:
            [self tutorialComplete];
            break;
    }
}


- (void)startTutorial
{
    _tutorialStep = 0;
    [self nextStep];
}

- (void)tutorialComplete
{
    [self removeFromSuperview];
    if (_delegate) {
        [_delegate tutorialComplete];
    }
}
@end
