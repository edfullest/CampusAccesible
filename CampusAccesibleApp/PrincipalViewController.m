//
//  PrincipalViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "PrincipalViewController.h"
#import "DetalleUbicacionTableViewController.h"
#import "PESGraph/PESGraph.h"
#import "PESGraph/PESGraphNode.h"
#import "PESGraph/PESGraphEdge.h"
#import "PESGraph/PESGraphRoute.h"
#import "PESGraph/PESGraphRouteStep.h"
#import "Vertice.h"
#import "IngresarRutaViewController.h"
#import "SWRevealViewController.h"

@import GoogleMaps;

@interface PrincipalViewController ()

@property PESGraphNode *pgnPrincipio;
@property PESGraphNode *pgnFinal;
@property NSInteger numMarkerSelected;        // Max value 2

@end

@implementation PrincipalViewController

- (void)viewDidLoad {
//    //Se cargan los datos de los nodos
//    NSString *pathPlist = [ [NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"];
//    self.nodes = [[NSArray alloc] initWithContentsOfFile: pathPlist];
//    
//    //Centro del tec: 25.651113, -100.290028
//    // Se posiciona la camara en el centro del Tec
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:25.651113
//                                                            longitude:-100.290028
//                                                                 zoom:17];
//     _mpvMapaTec =[GMSMapView mapWithFrame:_vwMain.bounds camera:camera];
//    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(25.651113, -100.290028);
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.title = @"Hello World";
//    marker.map = _mpvMapaTec;
//    
//   
//    
//    _mpvMapaTec = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    // http://stackoverflow.com/questions/23857744/google-maps-ios-sdk-get-tapped-overlay-coordinates
//    _mpvMapaTec.myLocationEnabled = YES;
//    
//    
//    
//    PESGraph *graph = [[PESGraph alloc] init];
//    //Se inicializan los nodos dentro del grafo
//    int i = 0;
//    for (NSDictionary* node in self.nodes) {
//        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:[@(i) stringValue] nodeWithDictionary:node];
//        
//        
//        i++;
//    }
//    [self.vwMain addSubview:_mpvMapaTec];
    
    [super viewDidLoad];
    _numMarkerSelected = 0;
    //Se cargan los datos de los nodos
    NSString *pathPlist = [ [NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"];
    self.nodes = [[NSArray alloc] initWithContentsOfFile: pathPlist];
    self.pesNodes = [[NSMutableArray alloc] init];
    
    pathPlist = [ [NSBundle mainBundle] pathForResource: @"ListaCaminos" ofType: @"plist"];
    self.edges = [[NSArray alloc] initWithContentsOfFile: pathPlist];
   
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.651113
                                                                                                  longitude:-100.290028
                                                                                                       zoom:17];
    
    //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    _mapView.delegate = self;
    _pgnPrincipio=[[PESGraphNode alloc]init];
    _pgnFinal=[[PESGraphNode alloc]init];
    
    
    _graph = [[PESGraph alloc] init];
    //Se inicializan los nodos dentro del grafo
    int i = 0;
    for (NSDictionary* node in self.nodes) {
        NSString *name = [[NSString alloc] initWithFormat:@"Nodo%d",i];
        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:name nodeWithDictionary:node];
        [self.pesNodes addObject:pgnNode];
        GMSMarker *mark=[[GMSMarker alloc]init];
        mark.position=CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        mark.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        mark.map = _mapView;
        mark.title = @"Nodo ";
        mark.userData  = @{@"Nodo":pgnNode};
        i++;
    }
    
    // Se pintan edges en mapa
    
    for (NSDictionary* edge in self.edges) {
        // Obten nodos del camino
        NSInteger posNodo1 = [[edge objectForKey:@"punto1"] intValue];
        NSInteger posNodo2 = [[edge objectForKey:@"punto2"] intValue];
        NSDictionary * nodo1 = [self.nodes objectAtIndex: posNodo1-1];
        NSDictionary * nodo2 = [self.nodes objectAtIndex: posNodo2-1];
        
        // Crear nodo de tipo PESGraphNode a partir de nodos
        PESGraphNode *pgnNode1 = [self.pesNodes objectAtIndex:posNodo1-1];
        PESGraphNode *pgnNode2 = [self.pesNodes objectAtIndex:posNodo2-1];
        
        // Calcular distancia entre nodos (coordenadas)
        float deltaLongitud = [[nodo1 objectForKey:@"longitud"] floatValue] - [[nodo2 objectForKey:@"longitud"] floatValue];
        float deltaLatitud = [[nodo1 objectForKey:@"latitud"] floatValue] - [[nodo2 objectForKey:@"latitud"] floatValue];
        float distancia = sqrtf( powf(deltaLatitud, 2.0) + powf(deltaLongitud, 2.0) );
        
        // Agregar edge al grafo
        [_graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:[NSString stringWithFormat:@"%ld<->%ld", (long)(posNodo1-1), (long)(posNodo2-1)] andWeight:[NSNumber numberWithFloat:distancia]] fromNode:pgnNode1 toNode:pgnNode2];
        
        GMSMutablePath *edgeEnMapa = [GMSMutablePath path];
        // Agrega coordenada de nodo1
        [edgeEnMapa addCoordinate:CLLocationCoordinate2DMake([[nodo1 objectForKey:@"longitud"] floatValue], [[nodo1 objectForKey:@"latitud"] floatValue])];
        // Agrega coordenada de nodo2
        [edgeEnMapa addCoordinate:CLLocationCoordinate2DMake([[nodo2 objectForKey:@"longitud"] floatValue], [[nodo2 objectForKey:@"latitud"] floatValue])];
        
        // Dibuja camino en el mapa
        GMSPolyline *rectangle = [GMSPolyline polylineWithPath:edgeEnMapa];
        
        // Asigna color de edge dependiendo de accesibilidad
        if ([[edge objectForKey:@"accesible"] boolValue] == YES) {
            rectangle.strokeColor = [UIColor blueColor];
        } else {
            rectangle.strokeColor = [UIColor redColor];
        }
        rectangle.strokeWidth = 2.f;
        rectangle.map = _mapView;
    }
    
    [self.vwMap insertSubview:_mapView atIndex:0];
    
//
    
//    PESGraphNode *aNode = [PESGraphNode nodeWithIdentifier:@"A"];
//    PESGraphNode *bNode = [PESGraphNode nodeWithIdentifier:@"B"];
//    PESGraphNode *cNode = [PESGraphNode nodeWithIdentifier:@"C"];
//    PESGraphNode *dNode = [PESGraphNode nodeWithIdentifier:@"D"];
//    PESGraphNode *eNode = [PESGraphNode nodeWithIdentifier:@"E"];
//    PESGraphNode *fNode = [PESGraphNode nodeWithIdentifier:@"F"];
//    
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> B" andWeight:[NSNumber numberWithInt:7]] fromNode:aNode toNode:bNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> C" andWeight:[NSNumber numberWithInt:9]] fromNode:aNode toNode:cNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> F" andWeight:[NSNumber numberWithInt:14]] fromNode:aNode toNode:fNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> C" andWeight:[NSNumber numberWithInt:10]] fromNode:bNode toNode:cNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> D" andWeight:[NSNumber numberWithInt:15]] fromNode:bNode toNode:dNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> F" andWeight:[NSNumber numberWithInt:2]] fromNode:cNode toNode:fNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> D" andWeight:[NSNumber numberWithInt:11]] fromNode:cNode toNode:dNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"D <-> E" andWeight:[NSNumber numberWithInt:6]] fromNode:dNode toNode:eNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"E <-> F" andWeight:[NSNumber numberWithInt:9]] fromNode:eNode toNode:fNode];
//    
//    PESGraphRoute *route = [graph shortestRouteFromNode:aNode toNode:eNode];
//    
//    for (PESGraphRouteStep *aStep in route.steps) {
//        
//        if (aStep.edge) {
//            
//            NSLog([NSString stringWithFormat:@"\t%@ -> %@\n", aStep.node.identifier, aStep.edge]);
//            
//        } else {
//            NSLog([NSString stringWithFormat:@"\t%@ (End)", aStep.node.identifier]);
//            //[string appendFormat:@"\t%@ (End)", aStep.node.identifier];
//            
//        }
//    }

    // Sidebar Navigation Menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    DetalleUbicacionTableViewController *detalleUbicacionTableViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"detalleUbicacionTableViewController"];
    [self.navigationController pushViewController:detalleUbicacionTableViewController animated:YES];
}

// Funcion que recibe el marker seleccionado
// http://www.g8production.com/post/60435653126/google-maps-sdk-for-ios-move-marker-and-info
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    mapView.selectedMarker = marker;
    if(_numMarkerSelected == 0){
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        _numMarkerSelected++;
        _pgnPrincipio = marker.userData[@"Nodo"];
    }
    else if (_numMarkerSelected == 1){
        marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
        _numMarkerSelected++;
        _pgnFinal = marker.userData[@"Nodo"];
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _mapView.selectedMarker = nil;
    [[segue destinationViewController] setPgnPrincipioI:_pgnPrincipio];
    [[segue destinationViewController] setPgnFinalI:_pgnFinal];
    [[segue destinationViewController] setGraphI:_graph];
}

- (IBAction)limpiarMapa:(id)sender {
    [self.mapView clear];
    _numMarkerSelected = 0;
    NSLog(@"Size %lu",(unsigned long)[self.pesNodes count]);
    for (PESGraphNode* pgnNode in self.pesNodes) {
        GMSMarker *mark=[[GMSMarker alloc]init];
        mark.position=CLLocationCoordinate2DMake([[pgnNode.additionalData objectForKey:@"longitud"] floatValue], [[pgnNode.additionalData  objectForKey:@"latitud"] floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        mark.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        mark.map = _mapView;
        mark.title = @"Nodo ";
        mark.userData  = @{@"Nodo":pgnNode};

        
    }
    
}
@end
