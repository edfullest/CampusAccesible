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

@interface IngresarRutaViewController : UIViewController <GMSMapViewDelegate>
@property (nonatomic,strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *vwMap;
@property (strong, nonatomic) PESGraph *graphI;
@property (strong, nonatomic) PESGraphNode *pgnPrincipioI;
@property (strong, nonatomic) PESGraphNode *pgnFinalI;


@property (strong, nonatomic) NSArray *nodes;
@property (strong, nonatomic) NSArray *edges;
@property (strong, nonatomic) NSMutableArray * pesNodes;
@property (strong, nonatomic) NSMutableArray *puntos;
@property (strong, nonatomic) NSMutableArray *puntosClaveDeRutaCorta;
@property (strong, nonatomic) NSMutableArray *puntosClaveDeRutaCortaAccesible;



@end
