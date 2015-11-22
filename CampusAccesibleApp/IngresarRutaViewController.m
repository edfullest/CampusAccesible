//
//  IngresarRutaViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "IngresarRutaViewController.h"
#import "PrincipalViewController.h"
#import "PESGraph/PESGraph.h"
#import "PESGraph/PESGraphNode.h"
#import "PESGraph/PESGraphEdge.h"
#import "PESGraph/PESGraphRoute.h"
#import "PESGraph/PESGraphRouteStep.h"
#import "AppDelegate.h"
#import "PuntoClave.h"
#import "Descriptor.h"
#import "Camino.h"
#import "InfoWindowPunto.h"

@import GoogleMaps;

@interface IngresarRutaViewController ()

@property NSInteger numMarkerSelected;
@property PESGraphNode *pgnPrincipio;
@property PESGraphNode *pgnFinal;
@property GMSMutablePath *rutaCorta;
@property GMSMutablePath *rutaCortaAccesible;
@property GMSMarker * mrkPrincipio;
@property GMSMarker * mrkFinal;

@end

@implementation IngresarRutaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnLimpiar.hidden = YES;
    _numMarkerSelected = 0;
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.651113
                                                                  longitude:-100.290028
                                                                       zoom:17];
   //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    _mapView.delegate = self;
    GMSMarker *mrkPrincipio=[[GMSMarker alloc]init];
    GMSMarker *mrkFinal=[[GMSMarker alloc]init];
   
    int i = 0;
    CGSize cgsTamano = CGSizeMake(28.0f, 28.0f);
    UIImage *imgPin = [self image:[UIImage imageNamed:@"pin100.png"] scaledToSize:cgsTamano];
    for (NSDictionary* node in self.nodes) {
        NSString *name = [[NSString alloc] initWithFormat:@"Nodo%d",i];
        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:name nodeWithDictionary:node];
        [self.pesNodes addObject:pgnNode];
        GMSMarker *mark=[[GMSMarker alloc]init];
        mark.position=CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        mark.icon = imgPin;
        mark.map = _mapView;
        mark.title = @"Inicio";
        mark.userData  = @{@"Nodo":pgnNode};
        i++;
    }
    
    NSString *puntosClavePlist = [ [NSBundle mainBundle] pathForResource: @"PuntosClave" ofType: @"plist"];
    NSArray *arrPuntosClave = [[NSArray alloc] initWithContentsOfFile: puntosClavePlist];
    
    _puntos =[self alimentarDB:arrPuntosClave];
    _puntosClaveDeRutaCorta = [[NSMutableArray alloc] init];
    _puntosClaveDeRutaCortaAccesible = [[NSMutableArray alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.hidden = YES;
    [self.tabBarController sizeToFit];
    [self.vwMap sizeToFit];
    [self.vwMap insertSubview:_mapView atIndex:0];
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
    
    
    //[route descripcion];
    //Este arreglo se ocupa para obtener los edges o caminos de la ruta mas corta
    NSMutableArray *caminosRutaCorta = [[NSMutableArray alloc] init];
    NSMutableArray *caminosRutaCortaAccesible = [[NSMutableArray alloc] init];
    // Crear GMSMutablePath con coordenadas
    _rutaCorta = [GMSMutablePath path];
    
    
    // Inicializar GMSMutablePath con coordenadas de ruta mas corta
    for (PESGraphRouteStep *aStep in route.steps) {
        
        NSDictionary * node = aStep.node.additionalData;
        if (aStep.edge){
            [caminosRutaCorta addObject:aStep.edge];
        }
        
        [_rutaCorta addCoordinate:CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue])];
        
    }
    
    // El mismo procedimiento de arriba deberia hacerse para la ruta accesible.
    // Como actualmente solo tenemos un unico grafo, diremos que tambien la ruta corta accesible
    // es igual a la ruta corta
    // Ejecutar algoritmo de Dijkstra para ruta mas corta
    PESGraphRoute *accesibleRoute = [_graphI shortestRouteFromNode:comienzo toNode:final andAccesible:YES];
    
    // Crear GMSMutablePath con coordenadas
    _rutaCortaAccesible = [GMSMutablePath path];
    
    // Inicializar GMSMutablePath con coordenadas de ruta mas corta
    for (PESGraphRouteStep *aStep in accesibleRoute.steps) {
        
        if (aStep.edge){
            
            [caminosRutaCortaAccesible addObject:aStep.edge];
        }
        
        NSDictionary * node = aStep.node.additionalData;
        [_rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue])];
        
    }
    
    NSArray *rutas = [NSArray array];
    rutas = [[NSArray alloc] initWithObjects:_rutaCorta,_rutaCortaAccesible,caminosRutaCorta,caminosRutaCortaAccesible, nil];
    return rutas;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if (sender == self.btnRutaAccesible){
        PrincipalViewController *controlador = segue.destinationViewController;
        [controlador setRuta:_rutaCortaAccesible];
        [controlador setMrkPrincipio:_mrkPrincipio];
        [controlador setMrkFinal:_mrkFinal];
        if ([_puntosClaveDeRutaCorta count]!=0){
            [controlador setPuntosClaveDeRuta:_puntosClaveDeRutaCortaAccesible];
        }
        [controlador setLimpiaMapa:YES];
    }
    else if (sender == self.btnRutaNoAccesible){
        PrincipalViewController *controlador = segue.destinationViewController;
        [controlador setRuta:_rutaCorta];
        [controlador setMrkPrincipio:_mrkPrincipio];
        [controlador setMrkFinal:_mrkFinal];
        if ([_puntosClaveDeRutaCortaAccesible count]!=0){
            [controlador setPuntosClaveDeRuta:_puntosClaveDeRutaCorta];
        }
        
        [controlador setLimpiaMapa:YES];
    }
}


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
    
    _lineaSegmentada = [GMSPolyline polylineWithPath:path];
    _lineaSegmentada.map = self.mapView;
    _lineaSegmentada.spans = spans;
    _lineaSegmentada.strokeWidth = 4.f;
}

// Funcion que recibe el marker seleccionado
// http://www.g8production.com/post/60435653126/google-maps-sdk-for-ios-move-marker-and-info
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    _btnLimpiar.hidden = NO;
    mapView.selectedMarker = marker;
    CGSize cgsTamano = CGSizeMake(28.0f, 28.0f);
    UIImage *imgGoal = [self image:[UIImage imageNamed:@"goal100.png"] scaledToSize:cgsTamano];
    UIImage *imgPin = [self image:[UIImage imageNamed:@"pin100.png"] scaledToSize:cgsTamano];
    if(_numMarkerSelected == 0){
        marker.icon = imgGoal;
        _numMarkerSelected++;
        _pgnPrincipio = marker.userData[@"Nodo"];
    }
    else if (_numMarkerSelected == 1){
        self.tabBarController.hidden = NO;
        [self.mapView clear];
        //marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
        _numMarkerSelected++;
        _pgnFinal = marker.userData[@"Nodo"];
        
        _mrkPrincipio=[[GMSMarker alloc]init];
        _mrkFinal=[[GMSMarker alloc]init];
        
        _mrkPrincipio.position=CLLocationCoordinate2DMake([[_pgnPrincipio.additionalData objectForKey:@"longitud"] floatValue],
                                                         [[_pgnPrincipio.additionalData objectForKey:@"latitud"] floatValue]);
        _mrkPrincipio.groundAnchor=CGPointMake(0.5,0.5);
        _mrkPrincipio.icon = imgGoal;
        _mrkPrincipio.map=_mapView;
        _mrkPrincipio.title = @"Inicio";
        //mrkPrincipio = _mrkPrincipioI;
        [_mapView setSelectedMarker:_mrkPrincipio];
        _mrkFinal.position=CLLocationCoordinate2DMake([[_pgnFinal.additionalData objectForKey:@"longitud"] floatValue],
                                                     [[_pgnFinal.additionalData objectForKey:@"latitud"] floatValue]);
        _mrkFinal.groundAnchor=CGPointMake(0.5,0.5);
        _mrkFinal.icon = imgGoal;
        _mrkFinal.map=_mapView;
        _mrkFinal.title = @"Fin";
        
        
        //Se llama al metodo que obtiene ruta mas corta
        //Rutas es un arreglo que tiene la ruta más corta y la más corta y accesible
        NSArray *rutas = [self nodoComienzo:_pgnPrincipio nodoFinal:_pgnFinal];
        GMSMutablePath *rutaCorta = [rutas objectAtIndex:0];
        GMSMutablePath *rutaCortaAccesible = [rutas objectAtIndex:1];
        NSArray *caminosDeRutaCorta  = [rutas objectAtIndex:2];
        NSArray *caminosDeRutaCortaAccesible = [rutas objectAtIndex:3];
        
        for (PESGraphEdge *camino in caminosDeRutaCorta){
           
            NSArray *puntosClaveDeCamino = [self camino:camino.name];
            NSLog(@"Puntos claves regresados %ld",[puntosClaveDeCamino count]);
            for (PuntoClave *punto in puntosClaveDeCamino){
                NSLog(@"Punto %@",punto.idPuntoClave);
                [_puntosClaveDeRutaCorta addObject:punto];
                NSLog(@"Tamano %ld",[_puntosClaveDeRutaCorta count]);
            }
        }
        
        for (PESGraphEdge *camino in caminosDeRutaCortaAccesible){
            NSArray *puntosClaveDeCamino = [self camino:camino.name];
            
            for (PuntoClave *punto in puntosClaveDeCamino){
                [_puntosClaveDeRutaCortaAccesible addObject:punto];
            }
        }
        //Se dibujan las lineas
        
        /*GMSPolyline *rectangle = [GMSPolyline polylineWithPath:rutaCorta];
         rectangle.strokeColor = [UIColor blueColor];
         rectangle.strokeWidth = 4.f;
         rectangle.map = _mapView;*/
        
        // Dibujar ruta accesible
        
        _lineaCompleta = [GMSPolyline polylineWithPath:rutaCortaAccesible];
        _lineaCompleta.strokeColor = [UIColor blueColor];
        _lineaCompleta.strokeWidth = 4.f;
        _lineaCompleta.map = _mapView;
        
        // Dibujar ruta no accesible
        
        for (int i = 0; i < [_rutaCorta count] - 1; i ++) {
            CLLocationCoordinate2D co1 = [rutaCorta coordinateAtIndex:i];
            CLLocationCoordinate2D co2 = [rutaCorta coordinateAtIndex:i+1];
            
            CLLocation *lo1 = [[CLLocation alloc] initWithLatitude:co1.latitude longitude:co1.longitude];
            CLLocation *lo2 = [[CLLocation alloc] initWithLatitude:co2.latitude longitude:co2.longitude];
            
            [self drawDashedLineOnMapBetweenOrigin:lo1 destination:lo2];
        }

        
        
    }
    return YES;
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}



- (NSArray <PuntoClave *> *) camino: (NSString *) camino{
    NSLog(@"Camino recibido:%@",camino);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *contexto = [appDelegate managedObjectContext];
    
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Camino" inManagedObjectContext:contexto];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entidad];
    
    
    
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@" (idCamino = %@)", camino];
    
    [request setPredicate: predicado];
    NSError *error;
    //ejecuto el request
    NSArray *objetosMatch = [contexto executeFetchRequest: request error: &error];
    
    if (objetosMatch.count == 0){
        NSLog(@"Nada");
        return nil;
    }
    else{
        NSLog(@"Match");
        Camino *registroMatch = objetosMatch[0];
        
        NSArray *arrPuntos = registroMatch.tieneMuchosPuntosClave.allObjects;
        
        NSLog(@"%ld",[arrPuntos count]);
        return arrPuntos;
        
//        PuntoClave *puntoClave = [arrPuntos objectAtIndex:1];
//        [todosPuntos addObject:<#(nonnull id)#>]
        
//        NSLog(@"%@",puntoClave.latitud);
//        NSLog(@"%@",puntoClave.longitud);
//        NSArray *arrDescriptores = puntoClave.tieneMuchosDescriptores.allObjects;
//        NSLog(@"%ld",arrPuntos.count);
//        NSLog(@"%ld",arrDescriptores.count);
        
        
    }

    
    
    
}

- (NSMutableArray <PuntoClave *>  *) alimentarDB: (NSArray *) caminos{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *contexto = [appDelegate managedObjectContext];
    NSMutableArray *todosPuntos = [[NSMutableArray alloc] init];
    
    for(NSDictionary *camino in caminos){
        NSString *idCamino = [camino valueForKey:@"idCamino"];
        NSArray *puntos = [camino objectForKey:@"puntosClave"];
        Camino *nuevoCamino = [NSEntityDescription insertNewObjectForEntityForName:@"Camino" inManagedObjectContext:contexto];
        [nuevoCamino setValue:idCamino forKey:@"idCamino"];
        
        
        
        for(NSDictionary *punto in puntos){
            
            NSString *idPuntoClave = [punto valueForKey:@"idPuntoClave"];
            NSNumber *latitud = [punto valueForKey:@"latitud"];
            NSNumber *longitud = [punto valueForKey:@"longitud"];
            NSNumber *tipo = [punto valueForKey:@"tipo"];
            NSArray *descriptores = [punto objectForKey:@"descriptores"];
            
            PuntoClave *nuevoPunto = [NSEntityDescription insertNewObjectForEntityForName:@"PuntoClave" inManagedObjectContext:contexto];
            [nuevoPunto setValue:idPuntoClave forKey:@"idPuntoClave"];
            [nuevoPunto setValue:longitud forKey:@"longitud"];
            [nuevoPunto setValue:latitud forKey:@"latitud"];
            [nuevoPunto setValue:tipo forKey:@"tipo"];
            
            for (NSDictionary *descriptor in descriptores){
                Descriptor *nuevoDescriptor = [NSEntityDescription insertNewObjectForEntityForName:@"Descriptor" inManagedObjectContext:contexto];
                NSString *nombre = [descriptor valueForKey:@"nombre"];
                [nuevoDescriptor setValue:nombre forKey:@"nombre"];
                NSString *valor = [descriptor valueForKey:@"valor"];
                [nuevoDescriptor setValue:valor forKey:@"valor"];
                [nuevoPunto addTieneMuchosDescriptoresObject:nuevoDescriptor ];
            }
            
            [nuevoCamino addTieneMuchosPuntosClaveObject:nuevoPunto];
            [todosPuntos addObject:nuevoPunto];
            
        }
    }
    
    
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Camino" inManagedObjectContext:contexto];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entidad];
    
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@" (idCamino = %@)", @"83<->84"];
    
    [request setPredicate: predicado];
    NSError *error;
    //ejecuto el request
    NSArray *objetosMatch = [contexto executeFetchRequest: request error: &error];
    
    if (objetosMatch.count == 0){
        
    }
    else{
        NSLog(@"%ld",objetosMatch.count);
        Camino *registroMatch = objetosMatch[0];
        
        NSArray *arrPuntos = registroMatch.tieneMuchosPuntosClave.allObjects;
        PuntoClave *puntoClave = [arrPuntos objectAtIndex:1];
        NSLog(@"%@",puntoClave.latitud);
        NSLog(@"%@",puntoClave.longitud);
        NSArray *arrDescriptores = puntoClave.tieneMuchosDescriptores.allObjects;
        NSLog(@"%ld",arrPuntos.count);
        NSLog(@"%ld",arrDescriptores.count);
        
        
    }
    
    return todosPuntos;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"Chefe");
    
    NSUInteger indexOfTab = [[self.tabBarController items] indexOfObject:item];
    NSLog(@"Tab index = %u", (int)indexOfTab);
    if ((int)indexOfTab==0){
        [self.delegado conLinea:_lineaSegmentada conRuta:_rutaCorta conPrincipio:_mrkPrincipio conFinal:_mrkFinal conPuntosClave:_puntosClaveDeRutaCorta tipoDeRuta:NO];
        [self.delegado quitaVista];
    }
    else{
        [self.delegado conLinea:_lineaCompleta conRuta:_rutaCortaAccesible conPrincipio:_mrkPrincipio conFinal:_mrkFinal conPuntosClave:_puntosClaveDeRutaCortaAccesible tipoDeRuta:YES];
        [self.delegado quitaVista];
    }
    [_puntosClaveDeRutaCortaAccesible removeAllObjects];
    [_puntosClaveDeRutaCorta removeAllObjects];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)limpiarInicioFin:(id)sender {
    [self.mapView clear];
    _numMarkerSelected = 0;
    int i = 0;
    CGSize cgsTamano = CGSizeMake(28.0f, 28.0f);
    UIImage *imgPin = [self image:[UIImage imageNamed:@"pin100.png"] scaledToSize:cgsTamano];
    for (NSDictionary* node in self.nodes) {
        NSString *name = [[NSString alloc] initWithFormat:@"Nodo%d",i];
        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:name nodeWithDictionary:node];
        [self.pesNodes addObject:pgnNode];
        GMSMarker *mark=[[GMSMarker alloc]init];
        mark.position=CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        mark.icon = imgPin;
        mark.map = _mapView;
        mark.title = @"Inicio";
        mark.userData  = @{@"Nodo":pgnNode};
        i++;
    }
    _btnLimpiar.hidden = YES;
    _tabBarController.hidden = YES;
    [_puntosClaveDeRutaCortaAccesible removeAllObjects];
    [_puntosClaveDeRutaCorta removeAllObjects];
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size)){
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


@end
