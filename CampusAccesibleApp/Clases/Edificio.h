//
//  Edificio.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//


#import <UIKit/UIKit.h>

@interface Edificio : NSObject

@property (nonatomic, strong) NSString *sNombre;
@property (nonatomic, strong) NSString *sDescripcion;
@property (nonatomic, strong) NSString *sImagen;
@property NSInteger iNumPisos;
@property BOOL bEsAula;
@property BOOL bTieneElevadores;
- (id) initWithNombre: (NSString *) sNombre
      withDescripcion:(NSString *)sDescripcion
           withImagen: (NSString *) sImagen
         withNumPisos: (NSInteger) iNumPisos;


@end
