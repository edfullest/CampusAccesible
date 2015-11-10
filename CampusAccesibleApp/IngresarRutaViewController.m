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
    
    /*GMSPolyline *rectangle = [GMSPolyline polylineWithPath:rutaCorta];
    rectangle.strokeColor = [UIColor blueColor];
    rectangle.strokeWidth = 4.f;
    rectangle.map = _mapView;*/
    
    // Dibujar ruta accesible
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:rutaCortaAccesible];
    rectangle.strokeColor = [UIColor blueColor];
    rectangle.strokeWidth = 4.f;
    rectangle.map = _mapView;
    
    // Dibujar ruta no accesible
    
    for (int i = 0; i < [rutaCorta count] - 1; i ++) {
        CLLocationCoordinate2D co1 = [rutaCorta coordinateAtIndex:i];
        CLLocationCoordinate2D co2 = [rutaCorta coordinateAtIndex:i+1];
        
        CLLocation *lo1 = [[CLLocation alloc] initWithLatitude:co1.latitude longitude:co1.longitude];
        CLLocation *lo2 = [[CLLocation alloc] initWithLatitude:co2.latitude longitude:co2.longitude];
        
        [self drawDashedLineOnMapBetweenOrigin:lo1 destination:lo2];
    }
    
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
    PESGraphRoute *route = [_graphI shortestRouteFromNode:comienzo toNode:final andAccesible:NO];
    
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
    // Ejecutar algoritmo de Dijkstra para ruta mas corta
    PESGraphRoute *accesibleRoute = [_graphI shortestRouteFromNode:comienzo toNode:final andAccesible:YES];
    
    // Crear GMSMutablePath con coordenadas
    GMSMutablePath *rutaCortaAccesible = [GMSMutablePath path];
    
    // Inicializar GMSMutablePath con coordenadas de ruta mas corta
    for (PESGraphRouteStep *aStep in accesibleRoute.steps) {
        
        NSDictionary * node = aStep.node.additionalData;
        [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue])];
        
    }
    
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

- (void)drawDashedLineOnMapBetweenOrigin:(CLLocation *)originLocation destination:(CLLocation *)destinationLocation {
    //[self.mapView clear];
    
    CGFloat distance = [originLocation distanceFromLocation:destinationLocation];
    if (distance < 5.0f) return;
    
    // works for segmentLength 22 at zoom level 16; to have different length,
    // calculate the new lengthFactor as 1/(24^2 * newLength)
    CGFloat lengthFactor = 4.7093020352450285e-09;
    CGFloat zoomFactor = pow(2, self.mapView.camera.zoom + 8);
    CGFloat segmentLength = 1.f / (lengthFactor * zoomFactor);
    CGFloat dashes = floor(distance / segmentLength);
    CGFloat dashLatitudeStep = (destinationLocation.coordinate.latitude - originLocation.coordinate.latitude) / dashes;
    CGFloat dashLongitudeStep = (destinationLocation.coordinate.longitude - originLocation.coordinate.longitude) / dashes;
    
    CLLocationCoordinate2D (^offsetCoord)(CLLocationCoordinate2D coord, CGFloat latOffset, CGFloat lngOffset) =
    ^CLLocationCoordinate2D(CLLocationCoordinate2D coord, CGFloat latOffset, CGFloat lngOffset) {
        return (CLLocationCoordinate2D) { .latitude = coord.latitude + latOffset,
            .longitude = coord.longitude + lngOffset };
    };
    
    GMSMutablePath *path = GMSMutablePath.path;
    NSMutableArray *spans = NSMutableArray.array;
    CLLocation *currentLocation = originLocation;
    [path addCoordinate:currentLocation.coordinate];
    
    while ([currentLocation distanceFromLocation:destinationLocation] > segmentLength) {
        CLLocationCoordinate2D dashEnd = offsetCoord(currentLocation.coordinate, dashLatitudeStep, dashLongitudeStep);
        [path addCoordinate:dashEnd];
        [spans addObject:[GMSStyleSpan spanWithColor:UIColor.redColor]];
        
        CLLocationCoordinate2D newLocationCoord = offsetCoord(dashEnd, dashLatitudeStep / 2.f, dashLongitudeStep / 2.f);
        [path addCoordinate:newLocationCoord];
        [spans addObject:[GMSStyleSpan spanWithColor:UIColor.clearColor]];
        
        currentLocation = [[CLLocation alloc] initWithLatitude:newLocationCoord.latitude
                                                     longitude:newLocationCoord.longitude];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = self.mapView;
    polyline.spans = spans;
    polyline.strokeWidth = 4.f;
}

@end
