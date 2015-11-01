//
//  PuntoClave.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "PuntoClave.h"

@implementation PuntoClave

- (id) initWithLongitud: (CGFloat) fLongitud
                   withLatitud:(CGFloat)fLatitud
                      withTipo: (NSString *) sTipo{
    self = [super init];
    if (self){
        _fLongitud = fLongitud;
        _fLatitud = fLatitud;
        _sTipo = sTipo;
    }
    return self;
}
@end