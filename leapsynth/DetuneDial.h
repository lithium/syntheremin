//
//  DetuneDial.h
//  leapsynth
//
//  Created by Wiggins on 10/24/13.
//
//

#import "CSControl.h"

@interface DetuneDial : CSControl
{
    
    NSRect _octaveRect, _centsRect;
    NSDictionary *_textAttributes;
    
    NSPoint lastDragPoint;
    BOOL dragging;
    BOOL dragIsCoarse;

}


@property NSFont *font;
@end
