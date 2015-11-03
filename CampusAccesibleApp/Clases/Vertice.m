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

- (id) initWithIdVertice:(int) idVertice
             withLongitud: (CGFloat) fLongitud
              withLatitud: (CGFloat) fLatitud
           withNombreMapa: (NSString *) sNombreMapa {
    self = [super init];
    if (self){
        _idVertice = idVertice;
        _fLongitud = fLongitud;
        _fLatitud = fLatitud;
        _sNombreMapa = sNombreMapa;
    }
    return self;
}
@end