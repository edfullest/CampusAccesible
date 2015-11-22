//
//  DetalleUbicacionTableViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "DetalleUbicacionTableViewController.h"
#import "SWRevealViewController.h"
#import "SalonesAccesiblesTableViewController.h"
#import "BanosAccesiblesTableViewController.h"


@interface DetalleUbicacionTableViewController ()

@end

@implementation DetalleUbicacionTableViewController{
    NSArray *menuItems;     // Celdas
    NSInteger ancho;        // Ancho de la imagen
    NSInteger altura;       // Altura de la imagen
}

#pragma mark - Managing the edificio

// Asigna valores a la variable edificio
- (void)setEdificio:(id)newEdificio {
    if (_edificio != newEdificio) {
        _edificio = newEdificio;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Sidebar Navigation Menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // Identificadores de la celda
    menuItems = @[@"edificio", @"imagen", @"elevadores", @"banos", @"salones"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Variables para las imagenes de los edificios
    UIImage *originalImage = [[UIImage alloc]init];
    UIImage *resizedImage = [[UIImage alloc]init];
    // Obtiene el ancho del contentView
    ancho = cell.contentView.bounds.size.width * 0.9;
    altura = ancho * 1.15;
    
    // Asigna imágenes
    if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 1"]){
        originalImage = [UIImage imageNamed:@"aulas1V1.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 2"]){
        originalImage = [UIImage imageNamed:@"aulas2.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 6"]){
        originalImage = [UIImage imageNamed:@"aulas6.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centro de Biotecnología"]){
        originalImage = [UIImage imageNamed:@"centroBiotecnologia.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centrales"]){
        originalImage = [UIImage imageNamed:@"centrales.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"]){
        originalImage = [UIImage imageNamed:@"gimnasio.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"CIAP"]){
        originalImage = [UIImage imageNamed:@"ciap.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"CETEC"]){
        originalImage = [UIImage imageNamed:@"cetec.jpg"];
    }
    
    // Ajusta y centra imagen
    if([CellIdentifier isEqualToString:@"imagen"]){
        // Ajusta imagen
        resizedImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(ancho, altura)];
        // Centra imagen
        UIImageView * imgView = [[UIImageView alloc]initWithImage:resizedImage];
        imgView.frame=CGRectMake((cell.contentView.bounds.size.width/2)-(resizedImage.size.width/2),0, resizedImage.size.width, resizedImage.size.height);
        
        [cell.contentView addSubview:imgView];
    }
    
    // Da estilo a nombre del aula
    if ([CellIdentifier isEqualToString:@"edificio"]) {
        NSDictionary *object = self.edificio;
        cell.textLabel.text = [[object valueForKey:@"nombre"] description];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        [cell setFont:[UIFont boldSystemFontOfSize:22]];
    }
    
    // Asigna y ajusta la imagen del elevador
    if ([CellIdentifier isEqualToString:@"elevadores"]){
        // Crea imagen para asignarla
        UIImage *originalImage;
        if([[self.edificio valueForKey:@"elevador"] boolValue]){
            originalImage = [UIImage imageNamed:@"checked.png"];
        }
        else{
            originalImage = [UIImage imageNamed:@"unchecked.png"];
        }
        UIImage *resizedImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(25,25)];
        cell.imageView.image = resizedImage;
    }
    
    // Oculta la celda "Ver Salones Accesibles" si el edificio no tiene salones
    if ([CellIdentifier isEqualToString:@"salones"] && ([[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centrales"] || [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"])){
        cell.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cambia la altura de la celda
    if(indexPath.row == 1)
        return altura;
    else
        return 44;
}

// Función utilizada para ajustar la imagen
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue para "Ver Salones Accesibles"
    if ([[segue identifier] isEqualToString:@"salones"]) {
        NSDictionary *object1 = self.edificio;
        UINavigationController *navController = segue.destinationViewController;
        SalonesAccesiblesTableViewController *detalleController = [navController childViewControllers].firstObject;
        detalleController.edificio1 = object1;
    }
    // Segue para "Ver Banos Accesibles"
    else if ([[segue identifier] isEqualToString:@"banos"]) {
        NSDictionary *object1 = self.edificio;
        UINavigationController *navController = segue.destinationViewController;
        BanosAccesiblesTableViewController *detalleController = [navController childViewControllers].firstObject;
        detalleController.edificio1 = object1;
    }
}

@end
