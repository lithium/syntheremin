//
//  CSSlider.h
//  leapsynth
//
//  Created by Wiggins on 10/24/13.
//
//

#define kCoarseModifier  20
#define kFineModifier    50

#import "CSControl.h"

@interface CSSlider : CSControl
{
    NSPoint lastDragPoint;
    BOOL dragging;
    BOOL dragIsCoarse;

}
@end
