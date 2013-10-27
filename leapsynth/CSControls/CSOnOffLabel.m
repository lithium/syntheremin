//
//  CSOnOffLabel.m
//  leapsynth
//
//  Created by Wiggins on 10/27/13.
//
//

#import "CSOnOffLabel.h"

@implementation CSOnOffLabel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setToggled:(BOOL)flag
{
    [super setToggled:flag];
    
    for (NSView *subview in [self subviews]) {
        [subview setHidden:!toggled];
    }
}
- (void)drawRect:(NSRect)dirtyRect
{
    CGRect bounds = [self bounds];
    
    NSImage *image = [self toggled] ? onImage : offImage;
    NSSize imageSize = [image size];
    
    NSRect imageBounds = NSMakeRect(0,
                                    (bounds.size.height - imageSize.height)/2,
                                    imageSize.width,
                                    imageSize.height);
    [image drawInRect:imageBounds
             fromRect:NSMakeRect(0,0, imageSize.width, imageSize.height)
            operation:NSCompositeSourceOver
             fraction:1.0];
}

- (void)setButtonName:(NSString *)name
{
    offImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@_disconnected", name]];
    onImage = [NSImage imageNamed:[NSString stringWithFormat:@"%@_connected", name]];

    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    //ignore events
}

- (void)mouseUp:(NSEvent *)theEvent
{
    //ignore events
}
@end
