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
    // cambiar Title
    [self setTitle:@"Ingresar Ruta"];
    // Se oculta el boton de limpiado de mapa
    _btnLimpiar.hidden = YES;
    // Se inicializa el contador de marcadores seleccionados
    _numMarkerSelected = 0;

    // Creacion de objeto de camara centrado en campus
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.651113
                                                                  longitude:-100.290028
                                                                       zoom:17];
    //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    _mapView.delegate = self;
   
    // Inicializacion de marcadores de ruta en mapa
    int i = 0;
    CGSize cgsTamano = CGSizeMake(28.0f, 28.0f);
    UIImage *imgPin = [self image:[UIImage imageNamed:@"pin100.png"] scaledToSize:cgsTamano];
    // Creacion de marcadores basado en diccionario de nodos del grafo
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
    
    // Inicializacion de arreglo de puntos clave desde plist
    NSString *puntosClavePlist = [ [NSBundle mainBundle] pathForResource: @"PuntosClave" ofType: @"plist"];
    NSArray *arrPuntosClave = [[NSArray alloc] initWithContentsOfFile: puntosClavePlist];
    
    // Se crea una especie de "base de datos temporal" para almacenar las relaciones de puntos clave, descriptores y caminos,
    // haciendo uso de Core Data, y devolviendo un arreglo con todos los puntos clave del grafo
    _puntos =[self alimentarDB:arrPuntosClave];
    _puntosClaveDeRutaCorta = [[NSMutableArray alloc] init];
    _puntosClaveDeRutaCortaAccesible = [[NSMutableArray alloc] init];

    // Configuracion de tabBar usado para la seleccion de tipo de ruta
    self.tabBarController.delegate = self;
    self.tabBarController.hidden = YES;
    [self.tabBarController sizeToFit];

    // Configuracion del mapView
    [self.vwMap sizeToFit];
    [self.vwMap insertSubview:_mapView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Metodo que obtiene la ruta mas corta y la ruta mas corta accesible, con base en una coordenada comienzo y una final,
- (NSArray *)nodoComienzo:(PESGraphNode *) comienzo nodoFinal:(PESGraphNode *) final    {
    
    // Ejecutar algoritmo de Dijkstra para ruta mas corta
    PESGraphRoute *route = [_graphI shortestRouteFromNode:comienzo toNode:final andAccesible:NO];
    
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

    // Ejecutar algoritmo de Dijkstra para ruta mas corta y accesible
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
    
    // Integrar ruta corta (GMSMutablePath), ruta corta accesible (GMSMutablePath),
    // arreglo de caminos de ruta corta (NSMutableArray) y areglo de caminos de ruta corta accesible (NSMutableArray)
    // en un arreglo de respuesta unico, devuelto como valor de retorno
    NSArray *rutas = [NSArray array];
    rutas = [[NSArray alloc] initWithObjects:_rutaCorta,_rutaCortaAccesible,caminosRutaCorta,caminosRutaCortaAccesible, nil];
    return rutas;
}


#pragma mark - Navigation

// PreparForSegue usado para retornar a la pantalla principal
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Seleccion de ruta corta y accesible
    if (sender == self.btnRutaAccesible){
        PrincipalViewController *controlador = segue.destinationViewController;
        // Se pasa ruta, marcador de inicio, marcador de fin y puntos clave de ruta (en caso de tener)
        [controlador setRuta:_rutaCortaAccesible];
        [controlador setMrkPrincipio:_mrkPrincipio];
        [controlador setMrkFinal:_mrkFinal];
        if ([_puntosClaveDeRutaCorta count]!=0){
            [controlador setPuntosClaveDeRuta:_puntosClaveDeRutaCortaAccesible];
        }
        // Se limpia el contenido del mapa
        [controlador setLimpiaMapa:YES];
    }
    // Seleccion de ruta corta no accesible
    else if (sender == self.btnRutaNoAccesible){
        PrincipalViewController *controlador = segue.destinationViewController;
        // Se pasa ruta, marcador de inicio, marcador de fin y puntos clave de ruta (en caso de tener)
        [controlador setRuta:_rutaCorta];
        [controlador setMrkPrincipio:_mrkPrincipio];
        [controlador setMrkFinal:_mrkFinal];
        if ([_puntosClaveDeRutaCortaAccesible count]!=0){
            [controlador setPuntosClaveDeRuta:_puntosClaveDeRutaCorta];
        }
        // Se limpia el contenido del mapa
        [controlador setLimpiaMapa:YES];
    }
}

// Metodo para dibujar una linea segmentada sobre un mapView, a partir de un punto origen y un punto destino
// Creado por Milan Cermak y obtenido de:
// https://gist.github.com/milancermak/e0b959a5195d28133a1f
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
    
    // Se pasa el resultado a una variable GMSPolyline (para poder ser enviada de vuelta a
    // pantalla principal en caso de ser necesario) y se pinta el segmento en el mapView 
    _lineaSegmentada = [GMSPolyline polylineWithPath:path];
    _lineaSegmentada.map = self.mapView;
    _lineaSegmentada.spans = spans;
    _lineaSegmentada.strokeWidth = 4.f;
}

// Funcion que recibe el marker seleccionado
// Se implementa logica para deteccion de seleccion de punto origen y punto destino
// http://www.g8production.com/post/60435653126/google-maps-sdk-for-ios-move-marker-and-info
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    // Se visibiliza el boton de limpiar mapa
    _btnLimpiar.hidden = NO;
    // Se define el marcador actual como seleccionado
    mapView.selectedMarker = marker;

    // Configuracion de imagenes para marcadores seleccionados
    CGSize cgsTamano = CGSizeMake(28.0f, 28.0f);
    UIImage *imgGoal = [self image:[UIImage imageNamed:@"goal100.png"] scaledToSize:cgsTamano];
    UIImage *imgPin = [self image:[UIImage imageNamed:@"pin100.png"] scaledToSize:cgsTamano];

    // El marcador seleccionado es origen
    if(_numMarkerSelected == 0){
        // Se actualiza el icono de marcador origen
        marker.icon = imgGoal;
        _numMarkerSelected++;
        // Nodo de inicio es igual al nodo asociado con el marcador seleccionado
        _pgnPrincipio = marker.userData[@"Nodo"];
    }
    else if (_numMarkerSelected == 1){
        // Se visibiliza el tab bar de seleccion de tipo de ruta
        self.tabBarController.hidden = NO;

        // Se limpian marcadores de mapa
        [self.mapView clear];
        _numMarkerSelected++;
        // Nodo destino es igual al nodo asociado con el marcador seleccionado
        _pgnFinal = marker.userData[@"Nodo"];
        
        _mrkPrincipio=[[GMSMarker alloc]init];
        _mrkFinal=[[GMSMarker alloc]init];
        
        // Se inicializa marcador de inicio
        _mrkPrincipio.position=CLLocationCoordinate2DMake([[_pgnPrincipio.additionalData objectForKey:@"longitud"] floatValue],
                                                         [[_pgnPrincipio.additionalData objectForKey:@"latitud"] floatValue]);
        _mrkPrincipio.groundAnchor=CGPointMake(0.5,0.5);
        _mrkPrincipio.icon = imgGoal;
        _mrkPrincipio.map=_mapView;
        _mrkPrincipio.title = @"Inicio";
        [_mapView setSelectedMarker:_mrkPrincipio];

        // Se inicializa marcador destino
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
        
        // Se obtienen puntos clave asociados a ruta corta
        for (PESGraphEdge *camino in caminosDeRutaCorta){
           
            NSArray *puntosClaveDeCamino = [self camino:camino.name];
            for (PuntoClave *punto in puntosClaveDeCamino){
                [_puntosClaveDeRutaCorta addObject:punto];
            }
        }
        
        // Se obtienen puntos clave asociados a ruta corta accesible
        for (PESGraphEdge *camino in caminosDeRutaCortaAccesible){
            NSArray *puntosClaveDeCamino = [self camino:camino.name];
            
            for (PuntoClave *punto in puntosClaveDeCamino){
                [_puntosClaveDeRutaCortaAccesible addObject:punto];
            }
        }
        
        // Dibujar ruta accesible
        
        _lineaCompleta = [GMSPolyline polylineWithPath:rutaCortaAccesible];
        _lineaCompleta.strokeColor = [UIColor blueColor];
        _lineaCompleta.strokeWidth = 4.f;
        _lineaCompleta.map = _mapView;
        
        // Dibujar ruta no accesible
        
        for (int i = 0; i < [_rutaCorta count] - 1; i ++) {
            // Se dibuja camino por camino, para poder utilizar metodo
            // de linea segmentada en cada trazo
            CLLocationCoordinate2D co1 = [rutaCorta coordinateAtIndex:i];
            CLLocationCoordinate2D co2 = [rutaCorta coordinateAtIndex:i+1];
            
            CLLocation *lo1 = [[CLLocation alloc] initWithLatitude:co1.latitude longitude:co1.longitude];
            CLLocation *lo2 = [[CLLocation alloc] initWithLatitude:co2.latitude longitude:co2.longitude];
            
            [self drawDashedLineOnMapBetweenOrigin:lo1 destination:lo2];
        }

        
        
    }
    return YES;
}

// Metodo utilizado para obtener un arreglo de puntos clave asociados a un camino,
// haciendo uso de Core Data
- (NSArray <PuntoClave *> *) camino: (NSString *) camino{

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *contexto = [appDelegate managedObjectContext];
    
    // Creacion de entidad de tipo Camino
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Camino" inManagedObjectContext:contexto];    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entidad];
    
    // Creacion de predicado de request    
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@" (idCamino = %@)", camino];
    [request setPredicate: predicado];

    NSError *error;
    
    // Ejecucion de request
    NSArray *objetosMatch = [contexto executeFetchRequest: request error: &error];
    
    // No se encontraron puntos clave asociados al camino
    if (objetosMatch.count == 0){
        return nil;
    }
    // Si se encontraron puntos clave asociados al camino
    else {
        Camino *registroMatch = objetosMatch[0];
        NSArray *arrPuntos = registroMatch.tieneMuchosPuntosClave.allObjects;
        return arrPuntos;   
    }  

}

// Metodo utilizado para crear una clase de "base de datos temporal" con las relaciones
// entre puntos clave, descriptores y caminos, a partir del arreglo de caminos, usando Core Data
- (NSMutableArray <PuntoClave *>  *) alimentarDB: (NSArray *) caminos{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *contexto = [appDelegate managedObjectContext];

    // Arreglo que almacena todos los puntos clave localizados en los caminos del grafo
    NSMutableArray *todosPuntos = [[NSMutableArray alloc] init];
    
    // Iterar sobre cada camino en el arreglo de caminos
    for(NSDictionary *camino in caminos) {

        // Se extraen datos del camino
        NSString *idCamino = [camino valueForKey:@"idCamino"];
        NSArray *puntos = [camino objectForKey:@"puntosClave"];

        // Se crea una nueva entidad Camino en Core Data
        Camino *nuevoCamino = [NSEntityDescription insertNewObjectForEntityForName:@"Camino" inManagedObjectContext:contexto];
        [nuevoCamino setValue:idCamino forKey:@"idCamino"];
        
        // Iterar sobre cada punto en el arreglo de puntos clave del camino en cuestion     
        for(NSDictionary *punto in puntos){
            
            // Se extraen datos del punto
            NSString *idPuntoClave = [punto valueForKey:@"idPuntoClave"];
            NSNumber *latitud = [punto valueForKey:@"latitud"];
            NSNumber *longitud = [punto valueForKey:@"longitud"];
            NSNumber *tipo = [punto valueForKey:@"tipo"];
            NSArray *descriptores = [punto objectForKey:@"descriptores"];
            
            // Se crea una nueva entidad PuntoClave en Core Data
            PuntoClave *nuevoPunto = [NSEntityDescription insertNewObjectForEntityForName:@"PuntoClave" inManagedObjectContext:contexto];
            [nuevoPunto setValue:idPuntoClave forKey:@"idPuntoClave"];
            [nuevoPunto setValue:longitud forKey:@"longitud"];
            [nuevoPunto setValue:latitud forKey:@"latitud"];
            [nuevoPunto setValue:tipo forKey:@"tipo"];
            
            // Se itera sobre cada descriptor en el arreglo de descriptores del punto clave en cuestion
            for (NSDictionary *descriptor in descriptores){
                Descriptor *nuevoDescriptor = [NSEntityDescription insertNewObjectForEntityForName:@"Descriptor" inManagedObjectContext:contexto];
                NSString *nombre = [descriptor valueForKey:@"nombre"];
                [nuevoDescriptor setValue:nombre forKey:@"nombre"];
                NSString *valor = [descriptor valueForKey:@"valor"];
                [nuevoDescriptor setValue:valor forKey:@"valor"];
                [nuevoPunto addTieneMuchosDescriptoresObject:nuevoDescriptor ];
            }
            
            // Se agrega punto clave al camino actual
            [nuevoCamino addTieneMuchosPuntosClaveObject:nuevoPunto];
            // Se agrega punto al arreglo de puntos
            [todosPuntos addObject:nuevoPunto];
            
        }
    }
    
    return todosPuntos;
}

// Metodo que detecta el evento de seleccion de elemento en el Tab Bar de seleccion de tipo de ruta
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

    // Se extrae indice del tab seleccionado    
    NSUInteger indexOfTab = [[self.tabBarController items] indexOfObject:item];

    // Se selecciona ruta corta
    if ((int)indexOfTab==0){
        // Se solicita a delegado (PrincipalViewController) que dibuje ruta corta en mapa
        [self.delegado conLinea:_lineaSegmentada conRuta:_rutaCorta conPrincipio:_mrkPrincipio conFinal:_mrkFinal conPuntosClave:_puntosClaveDeRutaCorta tipoDeRuta:NO];
        [self.delegado quitaVista];
    }
    // Se selecciona ruta corta accesible
    else{
        // Se colicita a delegado (PrincipalViewController) que dibuje ruta corta accesible en mapa
        [self.delegado conLinea:_lineaCompleta conRuta:_rutaCortaAccesible conPrincipio:_mrkPrincipio conFinal:_mrkFinal conPuntosClave:_puntosClaveDeRutaCortaAccesible tipoDeRuta:YES];
        [self.delegado quitaVista];
    }

    // Se borra contenido de arreglos de puntos clave
    [_puntosClaveDeRutaCortaAccesible removeAllObjects];
    [_puntosClaveDeRutaCorta removeAllObjects];
}

// Metodo asociado a boton de Limpiar, el cual reanuda el mapa
// a su estado original previo a la seleccion de marcadores
- (IBAction)limpiarInicioFin:(id)sender {
    
    // Se limpia mapa por completo
    [self.mapView clear];
    // Se reinicializa contador de marcadores seleccionados
    _numMarkerSelected = 0;

    // Se vuelven a dibujar en mapa los marcadores originales
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

    // Se oculta boton de limpiar
    _btnLimpiar.hidden = YES;
    // Se oculta tab bar de seleccion de ruta
    _tabBarController.hidden = YES;
    // Se elimina contenido de arreglos de puntos clave
    [_puntosClaveDeRutaCortaAccesible removeAllObjects];
    [_puntosClaveDeRutaCorta removeAllObjects];
}

// Metodo auxiliar usado para reajustar el tamano de una imagen
// a partir de ciertas dimensiones.
// Obtenido de: http://stackoverflow.com/questions/14649376/resize-uiimage-and-change-the-size-of-uiimageview
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
