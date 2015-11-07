//
//  IngresarRutaViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "IngresarRutaViewController.h"
#import "PESGraph/PESGraph.h"
#import "PESGraph/PESGraphNode.h"
#import "PESGraph/PESGraphEdge.h"
#import "PESGraph/PESGraphRoute.h"
#import "PESGraph/PESGraphRouteStep.h"

@interface IngresarRutaViewController ()

@end

@implementation IngresarRutaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[[_pgnPrincipioI.additionalData objectForKey:@"longitud"] floatValue]
                                                          longitude:[[_pgnPrincipioI.additionalData objectForKey:@"latitud"] floatValue]
                                                          zoom:18];
   //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    GMSMarker *mrkPrincipio=[[GMSMarker alloc]init];
    GMSMarker *mrkFinal=[[GMSMarker alloc]init];
   
    //Se posicionan los marcadores de la vista
    mrkPrincipio.position=CLLocationCoordinate2DMake([[_pgnPrincipioI.additionalData objectForKey:@"longitud"] floatValue],
                                                     [[_pgnPrincipioI.additionalData objectForKey:@"latitud"] floatValue]);
    mrkPrincipio.groundAnchor=CGPointMake(0.5,0.5);
    mrkPrincipio.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    mrkPrincipio.map=_mapView;
    mrkPrincipio.title = @"Inicio";
    //mrkPrincipio = _mrkPrincipioI;
    [_mapView setSelectedMarker:mrkPrincipio];
    mrkFinal.position=CLLocationCoordinate2DMake([[_pgnFinalI.additionalData objectForKey:@"longitud"] floatValue],
                                                 [[_pgnFinalI.additionalData objectForKey:@"latitud"] floatValue]);
    mrkFinal.groundAnchor=CGPointMake(0.5,0.5);
    mrkFinal.icon = [GMSMarker markerImageWithColor:[UIColor purpleColor]];
    mrkFinal.map=_mapView;
    mrkFinal.title = @"Fin";
 

    //Se llama al metodo que obtiene ruta mas corta
    //Rutas es un arreglo que tiene la ruta más corta y la más corta y accesible
    NSArray *rutas = [self nodoComienzo:_pgnPrincipioI nodoFinal:_pgnFinalI];
    GMSMutablePath *rutaCorta = [rutas objectAtIndex:0];
    GMSMutablePath *rutaCortaAccesible = [rutas objectAtIndex:1];
    
    //Se dibujan las lineas
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:rutaCorta];
    rectangle.strokeColor = [UIColor blueColor];
    rectangle.strokeWidth = 2.f;
    rectangle.map = _mapView;
    
    GMSPolyline *rectangle2 = [GMSPolyline polylineWithPath:rutaCortaAccesible];
    rectangle2.strokeColor = [UIColor redColor];
    rectangle2.strokeWidth = 2.f;
    rectangle2.map = _mapView;
    
    
    [self.vwMap addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)addX:(int)x toY:(int)y {
          int sum = x + y;
          return sum;
}



//Metodo que obtiene la ruta mas corta y la ruta mas corta accesible, con base en una coordenada comienzo y una final
- (NSArray *)nodoComienzo:(PESGraphNode *) comienzo nodoFinal:(PESGraphNode *) final    {
    
    // Ejecutar algoritmo de Dijkstra para ruta mas corta
    PESGraphRoute *route = [_graphI shortestRouteFromNode:comienzo toNode:final];
    
    // Crear GMSMutablePath con coordenadas
    GMSMutablePath *rutaCorta = [GMSMutablePath path];
    
    // Inicializar GMSMutablePath con coordenadas de ruta mas corta
    for (PESGraphRouteStep *aStep in route.steps) {
        
        NSDictionary * node = aStep.node.additionalData;
        [rutaCorta addCoordinate:CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue])];
        
    }
    
    // El mismo procedimiento de arriba deberia hacerse para la ruta accesible.
    // Como actualmente solo tenemos un unico grafo, diremos que tambien la ruta corta accesible
    // es igual a la ruta corta
    GMSMutablePath *rutaCortaAccesible = [GMSMutablePath path];
    rutaCortaAccesible = rutaCorta;
    
    NSArray *rutas = [NSArray array];
    rutas = [[NSArray alloc] initWithObjects:rutaCorta,rutaCortaAccesible, nil];
    return rutas;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
