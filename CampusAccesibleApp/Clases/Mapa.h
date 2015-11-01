//
//  Mapa.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//


#import <UIKit/UIKit.h>

@interface Mapa : NSObject

@property (nonatomic, strong) NSString *sNombreMapa;
@property (nonatomic, strong) NSString *sCiudad;
@property (nonatomic, strong) NSString *sEstado;
@property (nonatomic, strong) NSString *sPais;
@property CGFloat fLongitudCentro;
@property CGFloat fLatitudCentro;
@property CGFloat fLimiteEste;
@property CGFloat fLimiteOeste;
@property CGFloat fLimiteNorte;
@property CGFloat fLimiteSur;
- (id) initWithNombreMapa: (NSString *) sNombreMapa
      withCiudad:(NSString *)sCiudad
           withEstado: (NSString *) sEstado
            withPais: (NSString *) sPais
        withLongitudCentro: (CGFloat) fLongitudCentro
       withLatitudCentro: (CGFloat) fLatitudCentro
        withLimiteEste: (CGFloat) fLimitudEste
        withLimiteOeste: (CGFloat) fLimiteOeste
         withLimiteNorte: (CGFloat) fLimiteNorte
            withLimiteSur: (CGFloat) fLimiteSur;


@end
