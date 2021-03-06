//
//  MAOInitialViewController.m
//  MyAppOne
//
//  Created by Julio Castillo on 9/1/19.
//  Copyright © 2019 iOS-accelerator. All rights reserved.
//

#import "MAOInitialViewController.h"
#import "MAOListViewController.h"
#import "ItunesService.h"
#import "ItunesSong.h"
#import "MAOListViewController.h"
#import "ItunesSong.h"


/**
 Initial View Controller implementation.
 */
@implementation MAOInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner.hidesWhenStopped = YES;
}


/**
 Method to obtain the model list from the itunes song list

 @param songs NSArray of ItunesSongs
 @return NSMutableArray of MAOListViewControllerModel
 */
- (NSMutableArray<MAOListViewControllerModel *> *)getModeListFromItuneSongs:(NSArray *)songs {
    NSMutableArray<MAOListViewControllerModel *> *maoListModel = [[NSMutableArray alloc] init];
    
    for(ItunesSong *song in songs){
        MAOListViewControllerModel * maoListViewControllerModel = [[MAOListViewControllerModel alloc] initWithItunesSong: song];
        [maoListModel addObject:maoListViewControllerModel];
    }
    return maoListModel;
}


/**
 Method to start the list view with model.

 @param songs List of Itunes songs
 */
- (void)initializeViewListWitSongs:(NSArray *)songs {
    NSMutableArray<MAOListViewControllerModel *> * maoListModel = [self getModeListFromItuneSongs:songs];
    
    MAOListViewController *maoListViewController = [[MAOListViewController alloc] initWithModel:maoListModel];
    [maoListViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:maoListViewController animated:YES];
}


/**
 Method to show a general error
 */
- (void)generalErrorToast:(NSString *) message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

/**
 Click on "buscar" button action.

 @param sender the button
 */
- (IBAction)onClickSelection:(id)sender {
    
    [self.spinner startAnimating];
    [[ItunesService instance] getSongsByQuery:self.songSarchText.text andCompletitionBlock:^(NSArray *songsArray, NSError *error) {
        if (!error) {
            [self initializeViewListWitSongs:songsArray];
            [self.spinner stopAnimating];
        }
        else
        {
            [self.spinner stopAnimating];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self generalErrorToast: @"Error cargando canciones, consulte al alumno."];
            }];
        }
    }];
    
    // MARK: exercice description.
    
    // TODO
    // ACA BUSCAMOS LA DATA DEL SERVER Y AVANZAMOS AL PROXIMO VC CUANDO YA LA TENGAMOS PROCESADA
    
    // 1-  Request al server (URL: https://itunes.apple.com/search?term=jack+johnson)
    // 2 - Parser del response
    // 3 - Crecion del modelo del VC 2
    // 4 - Iniciar el vc 2 con el modelo
    //-------------------------------------------
    
    //NTH:
    // Manejo de errores en el request.
    // Mostrar mensaje mientras carga.
    // Mensajes de alerta.
}

@end
