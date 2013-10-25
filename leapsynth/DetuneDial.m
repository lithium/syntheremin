//
//  DetuneDial.m
//  leapsynth
//
//  Created by Wiggins on 10/24/13.
//
//

#import "DetuneDial.h"

@implementation DetuneDial


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _font = [NSFont fontWithName:@"Helvetica" size:22.0];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSCenterTextAlignment];
        _textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
            style, NSParagraphStyleAttributeName,
            _font, NSFontAttributeName,
         nil];

        NSRect bounds = [self bounds];
        int padding=5;
        _octaveRect = NSMakeRect(padding, padding,
                                 bounds.size.width/2-padding*2,
                                 bounds.size.height-padding*2);
        _centsRect = NSMakeRect(padding+bounds.size.width/2, padding,
                                bounds.size.width/2-padding*2,
                                bounds.size.height-padding*2);
        
        [self setMaxValue:36];
        [self setMinValue:-36];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];

    [context saveGraphicsState];
    int octave = (int)floor(self.doubleValue);
    int cents = (int)floor((self.doubleValue - octave)*100);
    
    [[NSString stringWithFormat:@"%02d", octave] drawInRect:_octaveRect withAttributes:_textAttributes];
    [[NSString stringWithFormat:@"%02d", cents] drawInRect:_centsRect withAttributes:_textAttributes];
    
    NSBezierPath *path = [NSBezierPath alloc];
    [path appendBezierPathWithRect:[self bounds]];
    [path stroke];
    
    [context restoreGraphicsState];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    lastDragPoint = [NSEvent mouseLocation];
    dragIsCoarse = YES;
    dragging = YES;
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    lastDragPoint = [NSEvent mouseLocation];
    dragIsCoarse = NO;
    dragging = YES;
    
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint pos = [NSEvent mouseLocation];
    
    double newValue = value;
    if (dragIsCoarse) {
        double normal = (pos.y - lastDragPoint.y)/300;
        newValue = floor(normal*(maxValue - minValue)) + (value - floor(value));
    } else {
        double normal = (pos.y - lastDragPoint.y)/300;
        double n = normal*99 / 100;
        newValue = (value) + MIN(0.99,n);
        lastDragPoint = pos;
    }

    [self setDoubleValue:newValue];
}

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    [self mouseDragged:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    dragging = NO;
}
- (void)rightMouseUp:(NSEvent *)theEvent
{
    dragging = NO;
}

@end
