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
    //25.649956, -100.290231
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.649956 longitude:-100.290231 zoom:18];
   //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    GMSMarker *mrkPrincipio=[[GMSMarker alloc]init];
    GMSMarker *mrkFinal=[[GMSMarker alloc]init];
   
    //Se posicionan los marcadores de la vista
    mrkPrincipio.position=CLLocationCoordinate2DMake(25.649956, -100.290231);
    mrkPrincipio.groundAnchor=CGPointMake(0.5,0.5);
    mrkPrincipio.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    mrkPrincipio.map=_mapView;
    mrkPrincipio.title = @"Aulas 3";
    [_mapView setSelectedMarker:mrkPrincipio];
    mrkFinal.position=CLLocationCoordinate2DMake(25.651502, -100.289138);
    mrkFinal.groundAnchor=CGPointMake(0.5,0.5);
    mrkFinal.icon = [GMSMarker markerImageWithColor:[UIColor purpleColor]];
    mrkFinal.map=_mapView;
    mrkFinal.title = @"Cafeteria Centrales";
 
    CLLocationCoordinate2D crdComienzo = mrkPrincipio.position;
    CLLocationCoordinate2D crdFinal = mrkFinal.position;
    
    
    //Se llama al metodo que obtiene ruta mas corta
    NSArray *rutas = [self coordenadaComienzo:crdComienzo coordenadaFinal:crdFinal];
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


//Metodo que obtiene la ruta mas corta y la ruta mas corta accesible, en base a una coordenada comienzo y una final
- (NSArray *)coordenadaComienzo:(CLLocationCoordinate2D) comienzo coordenadaFinal:(CLLocationCoordinate2D) final    {
    //Se traza una ruta manualmente, empezando desde Aulas 3
    GMSMutablePath *rutaCorta = [GMSMutablePath path];
    [rutaCorta addCoordinate:comienzo];
    //25.650076, -100.290228
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.650076).doubleValue,@(-100.290228).doubleValue)];
    //25.650080, -100.290573
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.650080).doubleValue,@(-100.290573).doubleValue)];
    //25.650773, -100.290585
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.650773).doubleValue,@(-100.290585).doubleValue)];
    //25.650777, -100.290237
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.650777).doubleValue,@(-100.290237).doubleValue)];
    //25.651123, -100.290234
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.651123).doubleValue,@(-100.290234).doubleValue)];
    //25.651113, -100.289148
    [rutaCorta addCoordinate:CLLocationCoordinate2DMake(@(25.651113).doubleValue,@(-100.289148).doubleValue)];
    //Centrales: 25.651502, -100.289138
    [rutaCorta addCoordinate:final];
    
    GMSMutablePath *rutaCortaAccesible = [GMSMutablePath path];
    [rutaCortaAccesible addCoordinate:comienzo];
    //25.650076, -100.290228
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650076).doubleValue,@(-100.290228).doubleValue)];
    //25.650078, -100.289343
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650078).doubleValue,@(-100.289343).doubleValue)];
    //25.650219, -100.289193
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650219).doubleValue,@(-100.289193).doubleValue)];
    //25.650752, -100.289158
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650752).doubleValue,@(-100.289158).doubleValue)];
    //25.650821, -100.288937
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650821).doubleValue,@(-100.288937).doubleValue)];
    //25.650922, -100.288882
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.650922).doubleValue,@(-100.288882).doubleValue)];
    //25.651009, -100.288769
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.651009).doubleValue,@(-100.288769).doubleValue)];
    //25.651113, -100.288765
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.651113).doubleValue,@(-100.288765).doubleValue)];
    //25.651120, -100.288686
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.651120).doubleValue,@(-100.288686).doubleValue)];
    //25.651556, -100.288683
    [rutaCortaAccesible addCoordinate:CLLocationCoordinate2DMake(@(25.651556).doubleValue,@(-100.288683).doubleValue)];
    //Centrales: 25.651502, -100.289138
    [rutaCortaAccesible addCoordinate:final];
    
    NSArray *rutas = [NSArray array];
    rutas = [[NSArray alloc] initWithObjects:rutaCorta,rutaCortaAccesible, nil];
    return rutas;
}

//Metodo que obtiene la ruta mas corta y la ruta mas corta accesible, con base en una coordenada comienzo y una final
- (NSArray *)nodoComienzo:(PESGraphNode *) comienzo nodoFinal:(PESGraphNode *) final    {
    
    // Ejecutar algoritmo de Dijkstra para ruta mas corta
    PESGraphRoute *route = [_graph shortestRouteFromNode:comienzo toNode:final];
    
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
