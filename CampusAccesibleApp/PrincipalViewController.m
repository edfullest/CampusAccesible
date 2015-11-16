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
#import "IngresarRutaViewController.h"
#import "SWRevealViewController.h"
#import "PuntoClave.h"
#import "Descriptor.h"
#import "Camino.h"
#import "InfoWindowPunto.h"

@import GoogleMaps;

@interface PrincipalViewController ()

@property PESGraphNode *pgnPrincipio;
@property PESGraphNode *pgnFinal;
@property NSInteger numMarkerSelected;        // Max value 2

@end

@implementation PrincipalViewController

- (void)viewDidLoad {

    _limpiaMapa = NO;
    
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
        
        // Obtener tipo de edge
        BOOL esAccesible = [[edge objectForKey:@"accesible"] boolValue];
        
        // Calcular distancia entre nodos (coordenadas)
        float deltaLongitud = [[nodo1 objectForKey:@"longitud"] floatValue] - [[nodo2 objectForKey:@"longitud"] floatValue];
        float deltaLatitud = [[nodo1 objectForKey:@"latitud"] floatValue] - [[nodo2 objectForKey:@"latitud"] floatValue];
        float distancia = sqrtf( powf(deltaLatitud, 2.0) + powf(deltaLongitud, 2.0) );
        
        // Agregar edge al grafo
        [_graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:[NSString stringWithFormat:@"%ld<->%ld", (long)(posNodo1-1), (long)(posNodo2-1)] andWeight:[NSNumber numberWithFloat:distancia] andAccesible:esAccesible] fromNode:pgnNode1 toNode:pgnNode2];
    }
    
    [self.vwMap insertSubview:_mapView atIndex:0];
    


    // Sidebar Navigation Menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //Dibuja puntos clave
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setGraphI:_graph];
    [[segue destinationViewController] setNodes:_nodes];
    [[segue destinationViewController] setPesNodes:_pesNodes];
}

- (IBAction)limpiarMapa:(id)sender {
    [self.mapView clear];
}

- (IBAction)unwindRuta:(UIStoryboardSegue *) segue {
    [self.mapView clear];
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:_ruta];
    rectangle.strokeColor = [UIColor blueColor];
    rectangle.strokeWidth = 4.f;
    rectangle.map = _mapView;
    _mrkFinal.map = _mapView;
    _mrkPrincipio.map = _mapView;
    [self cargarPuntosClaveDeRuta];
}

-(void)cargarPuntosClaveDeRuta{
    UIImage *imgSilla = [UIImage imageNamed:@"rampa100.png"];
    UIImage *imgElevador = [UIImage imageNamed:@"elevador100.png"];
    UIImage *imgEscaleras = [UIImage imageNamed:@"escaleras.png"];
    UIImage *imgAcceso = [UIImage imageNamed:@"acceso100.png"];
    CGSize cgsTamano = CGSizeMake(32.0f, 32.0f);
    for (PuntoClave * punto in _puntosClaveDeRuta){
        
        NSMutableArray * arrRangosBold = [[NSMutableArray alloc] init];
        
        GMSMarker *mark=[[GMSMarker alloc]init];
        mark.position=CLLocationCoordinate2DMake([punto.latitud floatValue],[punto.longitud floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        
        if ([punto.tipo  isEqual: @"Elevador"]){
            mark.icon = [self image: imgElevador scaledToSize:cgsTamano];
        }
        else if ([punto.tipo  isEqual: @"Acceso"]){
            mark.icon = [self image: imgAcceso scaledToSize:cgsTamano];
        }
        else if ([punto.tipo  isEqual: @"Rampa"]){
            mark.icon = [self image: imgSilla scaledToSize:cgsTamano];
        }
        else if ([punto.tipo  isEqual: @"Escaleras"]){
            mark.icon = [self image: imgEscaleras scaledToSize:cgsTamano];
        }
        
        mark.map = _mapView;
        mark.title = punto.tipo;
        //mark.userData  = @{@"puntoClave":@YES};
        NSString * descriptores;
        
        int cont = 0;
        
        NSArray *arrDescriptores = punto.tieneMuchosDescriptores.allObjects;
        
        for (Descriptor * desc in arrDescriptores) {
            
            if (cont == 0) {
                NSRange aux = NSMakeRange([descriptores length], [desc.nombre length]);
                [arrRangosBold addObject:[NSValue valueWithRange:aux] ];
                
                descriptores = desc.nombre;
                descriptores = [descriptores stringByAppendingString:@": "];
                descriptores = [descriptores stringByAppendingString:desc.valor];
            } else {
                descriptores = [descriptores stringByAppendingString:@"\n"];
                
                NSRange aux = NSMakeRange([descriptores length], [desc.nombre length]);
                [arrRangosBold addObject:[NSValue valueWithRange:aux] ];
                
                descriptores = [descriptores stringByAppendingString:desc.nombre];
                descriptores = [descriptores stringByAppendingString:@": "];
                descriptores = [descriptores stringByAppendingString:desc.valor];
            }
            cont ++;
        }
        
        mark.userData  = @{@"puntoClave":@YES, @"descripcion":descriptores, @"rangosBold":arrRangosBold};
        
        
//        GMSMarker *mark=[[GMSMarker alloc]init];
//        mark.position=CLLocationCoordinate2DMake([punto.latitud floatValue],[punto.longitud floatValue]);
//        mark.groundAnchor=CGPointMake(0.5,0.5);
//        
//        mark.map = _mapView;
//        mark.title = punto.tipo;
//        
//        if ([punto.tipo  isEqual: @"Elevador"]){
//            mark.icon = [self image: imgElevador scaledToSize:cgsTamano];
//        }
//        else if ([punto.tipo  isEqual: @"Acceso"]){
//            mark.icon = [self image: imgAcceso scaledToSize:cgsTamano];
//        }
//        else if ([punto.tipo  isEqual: @"Rampa"]){
//            mark.icon = [self image: imgSilla scaledToSize:cgsTamano];
//        }
//        else if ([punto.tipo  isEqual: @"Escaleras"]){
//            mark.icon = [self image: imgEscaleras scaledToSize:cgsTamano];
//        }
//        //mark.userData  = @{@"puntoClave":@YES};
//        NSString * descriptores;
//        
//        int cont = 0;
//        
//        NSArray *arrDescriptores = punto.tieneMuchosDescriptores.allObjects;
//        
//        for (Descriptor * desc in arrDescriptores) {
//            
//            if (cont == 0) {
//                descriptores = desc.nombre;
//                descriptores = [descriptores stringByAppendingString:desc.valor];
//            } else {
//                descriptores = [descriptores stringByAppendingString:@"\n"];
//                descriptores = [descriptores stringByAppendingString:desc.nombre];
//                descriptores = [descriptores stringByAppendingString:desc.valor];
//            }
//            cont ++;
//        }
//        
//        mark.userData  = @{@"puntoClave":@YES, @"descripcion":descriptores};
        
    }
    
    
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

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    if ( marker.userData[@"puntoClave"] ) {
        InfoWindowPunto *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindowPunto" owner:self options:nil] objectAtIndex:0];
        
        view.lblDescripcion.lineBreakMode = NSLineBreakByWordWrapping;
        view.lblDescripcion.numberOfLines = 0;
        
        //view.lblDescripcion.text=marker.userData[@"descripcion"];
        
        view.lblTitulo.text=marker.title;
        
        
        
        view.imgImagen.image = [UIImage imageNamed:@"aulas1.jpg"];
        
        
        /*CGRect frame = view.lblDescripcion.frame;
         frame.size.height = view.bounds.size.height;
         view.lblDescripcion.frame = frame;*/
        
        //Calculate the expected size based on the font and linebreak mode of your label
        // FLT_MAX here simply means no constraint in height
        /*
         CGSize maximumLabelSize = CGSizeMake(216, FLT_MAX);
         
         CGSize expectedLabelSize = [view.lblDescripcion.text sizeWithFont:view.lblDescripcion.font constrainedToSize:maximumLabelSize lineBreakMode:view.lblDescripcion.lineBreakMode];
         
         CGRect newFrame = view.lblDescripcion.frame;
         newFrame.size.height = expectedLabelSize.height;
         view.lblDescripcion.frame = newFrame;*/
        
        NSInteger strLength = [marker.userData[@"descripcion"] length];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineHeightMultiple:1.3];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:marker.userData[@"descripcion"]];
        
        
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, strLength)];
        // Bold style
        
        NSMutableArray * arrRangosBold = marker.userData[@"rangosBold"];
        NSRange rango2 = [ [arrRangosBold objectAtIndex:0]   rangeValue];
        
        for (int i = 0; i < [arrRangosBold count]; i ++) {
            NSRange rango = [ [arrRangosBold objectAtIndex:i]   rangeValue];
            [attrString addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica-Bold" size:14.0f] range:rango];
        }
        
        /*for (NSObject * ranAux in arrRangosBold) {
         NSRange rango = [ranAux  rangeValue];
         [attrString addAttribute:NSFontAttributeName value:[ [UIFont fontWithName:view.lblDescripcion.font.fontName size:view.lblDescripcion.font.pointSize] fontName] range:rango];
         }*/
        
        view.lblDescripcion.attributedText = attrString;
        
        [view.lblDescripcion sizeToFit];
        
        CGFloat totalHeight = 0.0f;
        for (UIView *vi in view.subviews)
            if (totalHeight < vi.frame.origin.y + vi.frame.size.height) totalHeight = vi.frame.origin.y + vi.frame.size.height;
        
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - (totalHeight-view.bounds.size.height), view.bounds.size.width, totalHeight+15.0f)];
        
        view.layer.cornerRadius = 17;
        view.layer.borderWidth = 3;
        view.layer.borderColor = [[UIColor blackColor] CGColor];
        
        return view;
    } else {
        return nil;
    }
    
    
    
}




@end
