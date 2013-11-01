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
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self nextStep];
}
- (void)keyDown:(NSEvent *)theEvent
{
    [self nextStep];
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
            [self setFrameOrigin:NSMakePoint(50,620)];
            [_backgroundImage setFrameSize:NSMakeSize(275,55)];
            [_backgroundImage setImage:[NSImage imageNamed:@"popover_showControls"]];
            [_tutorialText setTitleWithMnemonic:@"Click for synthesizer controls"];
            [_tutorialText setFrame:NSMakeRect(10,10,285,24)];
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
