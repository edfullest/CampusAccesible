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
    NSArray *menuItems;
    NSInteger ancho;
    NSInteger altura;
}

#pragma mark - Managing the edificio

- (void)setEdificio:(id)newEdificio {
    if (_edificio != newEdificio) {
        _edificio = newEdificio;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Sidebar
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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
    ancho = cell.contentView.bounds.size.width * 0.9;
    altura = ancho * 1.15;
    
    if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 1"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"aulas1.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 2"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"aulas2.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Aulas 6"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"aulas6.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centro de Biotecnología"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"centroBiotecnologia.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centrales"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"centrales.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"gimnasio.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"CIAP"]){
        // Asigna imagen
        originalImage = [UIImage imageNamed:@"ciap.jpg"];
    }
    else if ([CellIdentifier isEqualToString:@"imagen"] && [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"CETEC"]){
        // Asigna imagen
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
    
    // Nombre del aula
    if ([CellIdentifier isEqualToString:@"edificio"]) {
        NSDictionary *object = self.edificio;
        cell.textLabel.text = [[object valueForKey:@"nombre"] description];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        [cell setFont:[UIFont boldSystemFontOfSize:22]];
    }
    // Cuenta con elevador
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
    // Desplegar salones accesibles
    if ([CellIdentifier isEqualToString:@"salones"] && ([[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Centrales"] || [[[self.edificio valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"])){
        cell.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
        return altura;
    else
        return 44;
}

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
    if ([[segue identifier] isEqualToString:@"salones"]) {
        NSDictionary *object1 = self.edificio;
        UINavigationController *navController = segue.destinationViewController;
        SalonesAccesiblesTableViewController *detalleController = [navController childViewControllers].firstObject;
        detalleController.edificio1 = object1;
    }
    else if ([[segue identifier] isEqualToString:@"banos"]) {
        NSDictionary *object1 = self.edificio;
        UINavigationController *navController = segue.destinationViewController;
        BanosAccesiblesTableViewController *detalleController = [navController childViewControllers].firstObject;
        detalleController.edificio1 = object1;
    }
}

@end
