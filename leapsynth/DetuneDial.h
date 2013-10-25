//
//  DetuneDial.h
//  leapsynth
//
//  Created by Wiggins on 10/24/13.
//
//

#import "CSSlider.h"

@interface DetuneDial : CSSlider
{
    
    NSRect _octaveRect, _centsRect;
    NSDictionary *_textAttributes;
    
}


@property NSFont *font;
@end
