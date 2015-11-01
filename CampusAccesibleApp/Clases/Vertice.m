//
//  Vertice.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Vertice.h"

@implementation Vertice

- (id) initWithLongitud: (CGFloat) fLongitud
            withLatitud: (CGFloat) fLatitud{
    self = [super init];
    if (self){
        _fLongitud = fLongitud;
        _fLatitud = fLatitud;
    }
    return self;
}
@end