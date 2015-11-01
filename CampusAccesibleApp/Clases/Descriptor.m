//
//  Descriptor.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Descriptor.h"

@implementation Descriptor

- (id) initWithNombre: (NSString *) sNombre withValor:sValor{
    self = [super init];
    if (self){
        _sNombre = sNombre;
        _sValor = sValor;
    }
    return self;
}
@end

