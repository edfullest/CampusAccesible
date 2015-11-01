//
//  Mapa.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Mapa.h"

@implementation Mapa

- (id) initWithNombreMapa: (NSString *) sNombreMapa
               withCiudad:(NSString *)sCiudad
               withEstado: (NSString *) sEstado
                withPais: (NSString *) sPais
       withLongitudCentro: (CGFloat) fLongitudCentro
        withLatitudCentro: (CGFloat) fLatitudCentro
           withLimiteEste: (CGFloat) fLimiteEste
          withLimiteOeste: (CGFloat) fLimiteOeste
          withLimiteNorte: (CGFloat) fLimiteNorte
            withLimiteSur: (CGFloat) fLimiteSur{
    self = [super init];
    if (self){
        _sNombreMapa = sNombreMapa;
        _sCiudad = sCiudad;
        _sPais = sPais;
        _sEstado = sEstado;
        _fLongitudCentro = fLongitudCentro;
        _fLatitudCentro = fLatitudCentro;
        _fLimiteEste = fLimiteEste;
        _fLimiteOeste = fLimiteOeste;
        _fLimiteNorte = fLimiteNorte;
        _fLimiteSur = fLimiteSur;
    }
    return self;
}
@end
