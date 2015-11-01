//
//  Edificio.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Edificio.h"

@implementation Edificio

- (id) initWithNombre: (NSString *) sNombre
      withDescripcion:(NSString *)sDescripcion
           withImagen: (NSString *) sImagen
         withNumPisos: (NSInteger) iNumPisos{
    self = [super init];
    if (self){
        _sNombre = sNombre;
        _sDescripcion = sDescripcion;
        _sImagen = sImagen;
        _iNumPisos = iNumPisos;
    }
    return self;
}
@end
