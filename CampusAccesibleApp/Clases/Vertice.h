//
//  Vertice.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//


#import <UIKit/UIKit.h>

@interface Vertice : NSObject

@property CGFloat fLongitud;
@property CGFloat fLatitud;

- (id) initWithLongitud: (CGFloat) fLongitud
            withLatitud: (CGFloat) fLatitud;


@end