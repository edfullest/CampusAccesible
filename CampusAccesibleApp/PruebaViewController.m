//
//  PruebaViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 11/9/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "PruebaViewController.h"
#import "AppDelegate.h"
#import "PuntoClave.h"
#import "Descriptor.h"
#import "Camino.h"

@interface PruebaViewController ()

@end

@implementation PruebaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.651113
                                                                  longitude:-100.290028
                                                                       zoom:17];
    
    //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:self.view.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    _mapView.delegate = self;
    // Do any additional setup after loading the view.
    
    NSString *puntosClavePlist = [ [NSBundle mainBundle] pathForResource: @"PuntosClave" ofType: @"plist"];
    NSArray *arrPuntosClave = [[NSArray alloc] initWithContentsOfFile: puntosClavePlist];
    
    _puntos =[self alimentarDB:arrPuntosClave];
   
    
   
    
    [self.view insertSubview:_mapView atIndex:0];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray <PuntoClave *>  *) alimentarDB: (NSArray *) caminos{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *contexto = [appDelegate managedObjectContext];
    NSMutableArray *todosPuntos = [[NSMutableArray alloc] init];
    
    for(NSDictionary *camino in caminos){
        NSString *idCamino = [camino valueForKey:@"idCamino"];
        NSArray *puntos = [camino objectForKey:@"puntosClave"];
        NSLog(idCamino);
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
        NSLog(@"Nada");
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

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    NSLog(@"%f",position.zoom);
    if (position.zoom >= 18){
        
        
        
        UIImage *image = [GMSMarker markerImageWithColor:[UIColor redColor]];
        for (PuntoClave * punto in _puntos){
            GMSMarker *mark=[[GMSMarker alloc]init];
            mark.position=CLLocationCoordinate2DMake([punto.latitud floatValue],[punto.longitud floatValue]);
            mark.groundAnchor=CGPointMake(0.5,0.5);
            mark.icon = image;
            mark.map = _mapView;
            mark.title = punto.tipo;
            
            
        }
    }
    else{
        [mapView clear];
    }
    
}


@end
