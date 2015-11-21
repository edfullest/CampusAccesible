//
//  IngresarRutaViewController.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PESGraph/PESGraph.h"
@import GoogleMaps;

@protocol ProtocoloDibujarRuta <NSObject>
- (void) conLinea :(GMSPolyline *)gmsLinea
           conRuta: (GMSMutablePath *) ruta
           conPrincipio: (GMSMarker *) mrkPrincipio
          conFinal: (GMSMarker *) mrkFinal
          conPuntosClave: (NSMutableArray *) puntosClave
        tipoDeRuta: (BOOL) tipo;
- (void) quitaVista;
@end

@interface IngresarRutaViewController : UIViewController <GMSMapViewDelegate,UITabBarDelegate>
@property (nonatomic,strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *vwMap;
@property (strong, nonatomic) PESGraph *graphI;
@property (strong, nonatomic) PESGraphNode *pgnPrincipioI;
@property (strong, nonatomic) PESGraphNode *pgnFinalI;
@property (nonatomic,strong) id <ProtocoloDibujarRuta> delegado;
@property (weak, nonatomic) IBOutlet UIButton *btnRutaAccesible;
@property (weak, nonatomic) IBOutlet UIButton *btnRutaNoAccesible;
@property (weak, nonatomic) IBOutlet UIButton *btnLimpiar;


@property (strong, nonatomic) NSArray *nodes;
@property (strong, nonatomic) NSArray *edges;
@property (strong, nonatomic) NSMutableArray * pesNodes;
@property (strong, nonatomic) NSMutableArray *puntos;
@property (strong, nonatomic) NSMutableArray *puntosClaveDeRutaCorta;
@property (strong, nonatomic) NSMutableArray *puntosClaveDeRutaCortaAccesible;
@property (strong, nonatomic) GMSPolyline *lineaSegmentada;
@property (strong, nonatomic) GMSPolyline *lineaCompleta;


@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;
- (IBAction)limpiarInicioFin:(id)sender;

@end
