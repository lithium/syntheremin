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
    if (_tutorialStep == 2)
    {
        _rightDone = YES;
    }
    else if (_tutorialStep == 3) {
        
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
    if (_tutorialStep == 2)
    {
        _leftDone = YES;
    }
    else if (_tutorialStep == 3) {
    
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
    if (_tutorialStep == 4) {
        [self nextStep];
    }

}
-(void)switchToTheremin
{
//    if (_tutorialStep == 4) {
//        [self nextStep];
//    }
}

- (void)nextStep
{
    NSView *content = [self superview];
    NSRect superBounds = [content frame];
    switch (++_tutorialStep) {
        case 1: //welcome
            [self setFrameSize:NSMakeSize(496,305)];
            [self setFrameOrigin:NSMakePoint(superBounds.size.width/2 - [self bounds].size.width/2,
                                             superBounds.size.height/2 - [self bounds].size.height/2)];
            
            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD1"]];
            break;
            
        case 2: //to begin, place hands above
            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD2"]];
            break;
            
        case 3: // how to play
            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD3"]];
            break;
            
        case 4: // show controls
            [self setFrame:NSMakeRect(50,620,397,70)];
            [_backgroundImage setFrame:NSMakeRect(0,0,397,70)];
            [_backgroundImage setImage:[NSImage imageNamed:@"tutorial-controls"]];
            break;

        case 5: //patches
            [self setFrameSize:NSMakeSize(496,305)];
            [self setFrameOrigin:NSMakePoint(superBounds.size.width/2 - [self bounds].size.width/2,
                                             superBounds.size.height/2 - [self bounds].size.height/2)];

            [_backgroundImage setFrame:NSMakeRect(0,0,496,305)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD4"]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(switchToSynth:)]) {
                [_delegate switchToSynth:self];
            }
            break;
            
        case 6: //lfo
            [self setFrame:NSMakeRect(60,550,355,130)];
            [_backgroundImage setFrame:NSMakeRect(0,0,355,130)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD5"]];
            break;
            
        case 7: //osc
            [self setFrame:NSMakeRect(70,435,355,120)];
            [_backgroundImage setFrame:NSMakeRect(0,0,355,120)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD6"]];
            break;
            
        case 8: // noise
            [self setFrame:NSMakeRect(550,540,355,120)];
            [_backgroundImage setFrame:NSMakeRect(0,0,355,120)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD7"]];
            break;
            
        case 9: // adsr
            [self setFrame:NSMakeRect(550,320,355,190)];
            [_backgroundImage setFrame:NSMakeRect(0,0,355,190)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD8"]];
            break;

        case 10:
            if (_delegate && [_delegate respondsToSelector:@selector(switchToTheremin:)]) {
                [_delegate switchToTheremin:self];
            }

            [self setFrame:NSMakeRect(120,60,355,110)];
            [_backgroundImage setFrame:NSMakeRect(0,0,355,110)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD9"]];
            break;
            
        case 11:
            [self setFrameSize:NSMakeSize(355,112)];
            [self setFrameOrigin:NSMakePoint(superBounds.size.width/2 - [self bounds].size.width/2,
                                             superBounds.size.height/2 - [self bounds].size.height/2)];
            
            [_backgroundImage setFrame:NSMakeRect(0,0,355,112)];
            [_backgroundImage setImage:[NSImage imageNamed:@"CARD10"]];
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
