//
//  ERViewController.m
//  ExifReader
//
//  Created by Arulprasad on 28/3/13.
//  Copyright (c) 2013 Arulprasad. All rights reserved.
//

#import "ERViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>


@interface ERViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *pickButton;
@property (nonatomic) UIImagePickerController *picker;

@property (nonatomic) BOOL firstTimeView;
@end

@implementation ERViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self pickButton] addTarget:self action:@selector(onPickButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    self.picker = [[UIImagePickerController alloc]init];


}

-(void) viewDidAppear:(BOOL)animated{
    if(!self.firstTimeView){
    [self showImagePicker];
    }
    self.firstTimeView = true;
}

-(void)onPickButtonTouchDown:(id) sender{
    [self showImagePicker];
}

-(void)showImagePicker{
    
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.picker.delegate = self;
    [self presentViewController: self.picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block NSMutableDictionary *imageMetadata = nil;
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset)  {
                 NSDictionary *metadata = asset.defaultRepresentation.metadata;
                 imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];
                 self.textView.text = imageMetadata.description;
                 [self.textView selectAll:self];
                 [self.imageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
             }
            failureBlock:^(NSError *error) {
            }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
