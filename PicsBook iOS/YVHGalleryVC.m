//
//  YVHGalleryVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHGalleryVC.h"
#import "YVHAppDelegate.h"
#import "Flickr.h"
#import "Pic.h"
#import "YVHPicVC.h"
#import "CVCell.h"
#import "FilterCell.h"
#import "YVHDAO.h"
#import <UIKit/UIKit.h>
#import "YVHUtil.h"


@interface YVHGalleryVC ()


@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;


//HeaderView
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *backButtonView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *numPicsView;
@property (weak, nonatomic) IBOutlet UILabel *numPicsLbl;
@property (weak, nonatomic) IBOutlet UILabel *numPicsTextLbl;

//OptionsViews
@property (weak, nonatomic) IBOutlet UIView *optionsAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsAlbumImg;
@property (weak, nonatomic) IBOutlet UIView *optionsOnePicView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsOnePicImg;
@property (assign, nonatomic) CGRect hiddenAlbumOptionsFrame;
@property (assign, nonatomic) CGRect hiddenOnePicOptionsFrame;
@property (assign, nonatomic) CGRect shownAlbumOptionsFrame;
@property (assign, nonatomic) CGRect shownOnePicOptionsFrame;
@property (strong, nonatomic) UIButton * AlbumOptionsBtn1;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn1;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn2;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn3;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn4;

//InfoViews
@property (weak, nonatomic) IBOutlet UIView *infoAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *infoAlbumImg;
@property (assign, nonatomic) CGRect hiddenInfoAlbumFrame;
@property (assign, nonatomic) CGRect shownInfoAlbumFrame;


@property (weak, nonatomic) IBOutlet UIView *infoPicView;
@property (weak, nonatomic) IBOutlet UIImageView *infoPicImg;
@property (assign, nonatomic) CGRect hiddenInfoPicFrame;
@property (assign, nonatomic) CGRect shownInfoPicFrame;

@property (weak, nonatomic) IBOutlet UILabel *nameTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *albumLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl2;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl3;
@property (weak, nonatomic) IBOutlet UILabel *longitudeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLbl;
@property (weak, nonatomic) IBOutlet UILabel *latitudeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLbl;
@property (weak, nonatomic) IBOutlet UILabel *facesTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *facesLbl;


//OnePic View
@property (weak, nonatomic) IBOutlet UIView *PicView;
@property (weak, nonatomic) IBOutlet UIImageView *PicViewImg;

//Filters
@property (strong, nonatomic) NSArray * filterList;
@property (weak, nonatomic) IBOutlet UIView *filtersView;
@property (weak, nonatomic) IBOutlet UICollectionView *filtersCollectionView;

@property (weak, nonatomic) IBOutlet UIView *filterDetailView;
@property (weak, nonatomic) IBOutlet UIView *filterDetailTitleTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *filterDetailTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailSaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailCancelBtn;

@property (assign, nonatomic) NSInteger pickedFilter;

@property (assign, nonatomic) CGRect hiddenFiltersFrame;
@property (assign, nonatomic) CGRect shownFiltersFrame;

@property (assign, nonatomic) CGRect hiddenFilterDetailFrame;
@property (assign, nonatomic) CGRect shownFilterDetailFrame;


//Others
@property (weak, nonatomic) IBOutlet UIButton *debugButton;

@property (nonatomic, strong) NSArray *picsArray;
@property (nonatomic, strong) UIImage * pickedImg;
@property (nonatomic, strong) Pic * pickedPic;
@property(nonatomic,assign) BOOL contextHasChange;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * city;
@property (strong, nonatomic) NSString * area;
@property (strong, nonatomic) NSString * country;
@property (strong, nonatomic) NSString * zip;

@property (strong, nonatomic) UIImage* lastPickedImg;





@end

@implementation YVHGalleryVC

//Vars

bool isShowingPicOptions = false;
bool isShowingAlbumOptions = false;
bool isOnePicView = false;
bool isShownAlbumInfo = false;
bool isShownFilters = false;
bool isShownFilterDetail = false;
bool isShownPicInfo = false;
bool isShownFaces = false;
bool isStatusBarHidden = false;
float showViewDuration = 0.1;
float hideViewDuration = 0.3;
int radius = 25;

#pragma mark -
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.address addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    //Change appeareance of uiviews
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    //Coredata Stack access
    self.managedObjectContext = [YVHDAO getContext];
    
    self.picsArray = [YVHDAO  getPics:nil];
    [YVHDAO setSelectedPics:self.picsArray];
    
    UINib *cellNib = [UINib nibWithNibName:@"CVCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];

    UINib *filterCellNib = [UINib nibWithNibName:@"FilterCell" bundle:nil];
    [self.filtersCollectionView registerNib:filterCellNib forCellWithReuseIdentifier:@"filterCell"];
    

    self.contextHasChange = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleDataModelChange:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object: self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchOptions)
                                                 name:@"GalleryOptions"
                                               object:nil];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.PicView addGestureRecognizer:singleFingerTap];
    
    [self initAlbumOptionsView];
    [self initOptionsOnePicView];
    //[self initAlbumInfoView];
    [self initFilterListView];
    [self initPicInfoView];
    [self initFilterDetailView];
    
    
#if DEBUG
    [self initDebugControls];
#endif
    
    self.filterList = @[@"CISepiaTone",//0
                        @"CIFalseColor"  ,//1
                        @"CIColorCube"    ,//2
                        //@"CICrop"     ,//3
                        @"CIColorInvert"    ,//4
                        @"CICircularScreen"    ,//5
                        //@"CICMYKHalftone"    ,//6
                        //@"CIColorClamp"    ,//7
                        //@"CIColorControls"    ,//8
                        //@"CIColorCrossPolynomial"    ,//9
                        @"CIColorPosterize"     ,//10
                        //@"CICrystallize"     ,//11
                        // @"CIEdges"     ,//12
                        // @"CIEdgeWork"     ,//13
                        //@"CIGlassDistortion"     ,//14
                        //@"CIGlassLozenge"     ,//15
                        //@"CIHighlightShadowAdjust"     ,//16
                        //@"CIHistogramDisplayFilter"     ,//17
                        //@"CIDroste"     ,//18
                        //@"CIConvolution7X7"     ,//19
                        //@"CIKaleidoscope"     ,//20
                        //@"CILineOverlay"     ,//21
                        //@"CIPerspectiveTile"     ,//22
                        @"CIPerspectiveTransform"     ,//23
                        @"CIPhotoEffectChrome"     ,//24
                        @"CIPhotoEffectMono"     ,//25
                        @"CIPhotoEffectNoir"     ,//26
                        @"CIPixellate"     ,//27
                        //@"CIQRCodeGenerator"     ,//28
                        //@"CIColorMap"     ,//29
                        //@"CIStraightenFilter"     ,//30
                        
                        ];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(self.contextHasChange){
        self.picsArray = [YVHDAO getPics:nil];
        [self.collectionView reloadData];
        if (isShownAlbumInfo){
            [self showAlbumInfo];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (isShowingPicOptions){
        [self switchOnePicOptions];
        isShowingPicOptions = false;
    }
    if (isShowingAlbumOptions){
        [self hideAlbumOptions];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"GalleryVC memory warning");
    // Dispose of any resources that can be recreated.
 //   self.collectionView = nil;
 //   self.picsArray = nil;
}

- (void)handleDataModelChange:(NSNotification *)note
{
//    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
//    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
//    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
    
    self.contextHasChange = YES;
}



#pragma mark - Utils

- (void)getReverseGeocodeLocation:(CLLocation *)selectedLocation{

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
      
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            self.address = [dictionary valueForKey:@"Street"];
            self.city = [dictionary valueForKey:@"City"];
            self.area = [dictionary valueForKey:@"SubAdministrativeArea"];
            self.country = [dictionary valueForKey:@"Country"];
            self.zip = [dictionary valueForKey:@"ZIP"];
            
            [self setAddressLocation];
        }
        else{
            self.address = nil;
            self.city = nil;
            self.area = nil;
            self.zip = nil;
            self.country = nil;
        }
    }];
    
}

-(void)setAddressLocation{
    self.addressTextLbl.text = NSLocalizedString(@"PIC_ADDRESS", nil);
    self.addressLbl.text = self.address;
    self.addressLbl2.text = [NSString stringWithFormat:@"%@ - %@ ", self.zip, self.city];
    self.addressLbl3.text = [NSString stringWithFormat:@"%@ %@", [self.area isEqualToString:self.city]?@"":[self.area stringByAppendingString: @" - " ], self.country];
}

- (void)setReverseGeocodeLocation{
    self.longitudeTextLbl.text = NSLocalizedString(@"PIC_LONG", nil);
    self.longitudeLbl.text = [self.pickedPic.longitude stringValue];
    self.latitudeTextLbl.text = NSLocalizedString(@"PIC_LAT", nil);
    self.latitudeLbl.text = [self.pickedPic.latitude stringValue];
    self.facesTextLbl.text = NSLocalizedString(@"PIC_FACES", nil);
    self.facesLbl.text = @"0";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"string");
    if (self.address ) {
        
    }
}

-(UIImage *) getPicFromDisk:(NSString*)path{
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    //UIImage *thumbNail = [UIImage imageNamed:@"2014-08-28 19.00.58.jpg"];
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    
    return img;
}

-(UIImage *) getThumnailFromDisk:(NSString*)path{
    NSString * thPath = [self convertToThPath:path];
    NSData *imgData = [NSData dataWithContentsOfFile:thPath];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    
    return thumbNail;
}

-(UIImage *) getThumnailFromUImage:(UIImage*)originalImage{

    CGSize destinationSize = CGSizeMake(135, 170);
    
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSString *)convertToThPath:(NSString*)path{
    //int len = [path length];
    return  [path stringByAppendingString:@"_s"];
}

-(CGImageRef )processingImage:(CIImage *)image
                       filter:(CIFilter *)filter{
    
    CIContext *context = [CIContext contextWithOptions:nil];        //1
    //CIImage *image = [CIImage imageWithContentsOfURL:urlImage];     //2
    CIImage *result = [filter valueForKey:kCIOutputImageKey];           //4
    CGImageRef cgImage = [context createCGImage:result
                                       fromRect:[result extent]];
    return cgImage;
}

-(UIImage *)standarFilterToImage:(UIImage *)image
                       filterName:(NSString *)filterName{
    
    CGImageRef cgimg = image.CGImage;
    CIImage * ciimage = [CIImage imageWithCGImage:cgimg];
    
    CIFilter * filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciimage forKey:kCIInputImageKey];
//    if ([filterName isEqualToString:@"CIColorMap"]) {
//        [filter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"inputGradientImage"];
//    }
         //  [filter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"InputIntensity"];
         
    CIContext *context = [CIContext contextWithOptions:nil];        //1
    CIImage *result = [filter valueForKey:kCIOutputImageKey];           //4
    CGImageRef cgImage = [context createCGImage:result
                                       fromRect:[result extent]];
    
    return [UIImage imageWithCGImage:cgImage];

}



#pragma mark - UI

- (IBAction)backToAlbum:(id)sender {
    self.PicView.hidden = true;
    self.collectionView.hidden = false;
    isStatusBarHidden = false;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if(self.contextHasChange){
        self.picsArray = [YVHDAO getPics:nil];
        [self.collectionView reloadData];
    }
    [YVHDAO setSelectedPics:self.picsArray];
    
    if(isShowingPicOptions){
        [self switchOnePicOptions];
        isShowingPicOptions = false;
    }    

    if(isShownAlbumInfo){
        [self showAlbumInfo];
    }
    else{
        [self hideAlbumInfo];
    }
    
    if(isShownFilters){
        [self hideFilters];
    }
    
    if (isShownFilterDetail) {
        [self hideFilterDetail];
        self.PicViewImg.image = self.pickedImg;
    }
    
    self.backButtonView.hidden = true;
    self.infoPicView.hidden = true;
    isOnePicView = false;
}

-(void)handleSingleTap{
    [self voidScreen];
    if (isShownFilterDetail) {
        self.PicViewImg.image = self.pickedImg;
    }
}

-(void)refitAlbumHeader{
    
    [self.titleLbl sizeToFit];
    self.titleLbl.center = CGPointMake(self.headerView.center.x,self.titleLbl.center.y);
    
    [self.numPicsTextLbl sizeToFit];

    
    self.numPicsView.frame = CGRectMake(self.titleLbl.frame.origin.x +  self.titleLbl.frame.size.width + 30, self.numPicsView.frame.origin.y , self.numPicsView.frame.size.width, self.numPicsView.frame.size.height);
    self.numPicsLbl.frame = CGRectMake(self.numPicsTextLbl.frame.origin.x +  self.numPicsTextLbl.frame.size.width + 5, self.numPicsLbl.frame.origin.y , self.numPicsLbl.frame.size.width, self.numPicsLbl.frame.size.height);
    

}


int optionHeight = 80;
int optionWidth = 165;
int iconWidth = 50;
float iconAlpha = .8;

-(void)initAlbumOptionsView
{
    int options = 1;
    int height = optionHeight * options;
    UIImage * btnImage;
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hiddenAlbumOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height, optionWidth, height);
    self.shownAlbumOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height - 57 - height, optionWidth, height);
    self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;
    
    self.optionsAlbumImg.image = [UIImage imageNamed:@"options1.png"];
    [self.view bringSubviewToFront:self.optionsAlbumView];
    
    //Buttons
    btnImage = [UIImage imageNamed:@"info.png"];
	self.AlbumOptionsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.AlbumOptionsBtn1.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
    self.AlbumOptionsBtn1.alpha = iconAlpha;
	[self.AlbumOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.optionsAlbumView addSubview:self.AlbumOptionsBtn1];
    [self.AlbumOptionsBtn1 addTarget:self action:@selector(switchAlbumInfoView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initOptionsOnePicView
{
    int options = 4;
    int height = optionHeight * options;
    UIImage * btnImage;
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hiddenOnePicOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height, optionWidth, height);
    self.shownOnePicOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height - 57 - height, optionWidth, height);
    self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;
    
    self.optionsOnePicImg.image = [UIImage imageNamed:@"options4.png"];
    [self.view bringSubviewToFront:self.optionsOnePicView];
    
    //Buttons
    btnImage = [UIImage imageNamed:@"face.png"];
	self.OnePicOptionsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn1.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn1.alpha = iconAlpha;
    [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn1 addTarget:self action:@selector(switchFaces) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn1];
    
    btnImage = [UIImage imageNamed:@"filter.png"];
	self.OnePicOptionsBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn2.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn2.alpha = iconAlpha;
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn2 addTarget:self action:@selector(toFilters) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn2];
    
    btnImage = [UIImage imageNamed:@"share.png"];
	self.OnePicOptionsBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn3.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*2 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn3.alpha = iconAlpha;
    [self.OnePicOptionsBtn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn3 addTarget:self action:@selector(toShare) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn3];
    
    btnImage = [UIImage imageNamed:@"info.png"];
	self.OnePicOptionsBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn4.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*3 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
    self.OnePicOptionsBtn4.alpha = iconAlpha;
	[self.OnePicOptionsBtn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn4 addTarget:self action:@selector(switchPicInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn4];
    
}

-(void)initAlbumInfoView{
  //  int options = 1;
  //  int height = optionHeight * options;
    int infoViewWidth = 450;
    int infoViewHeight = 400;
    
    //Bar image
    self.hiddenInfoAlbumFrame = CGRectMake(0 - infoViewWidth, 500, infoViewWidth, infoViewHeight);
    self.shownInfoAlbumFrame = CGRectMake(0 , 500, infoViewWidth, infoViewHeight);
    self.infoAlbumView.frame = self.hiddenInfoAlbumFrame;
    
    self.infoAlbumImg.image = [UIImage imageNamed:@"infoBg.png"];
    [self.view bringSubviewToFront:self.infoAlbumView];
}

-(void)initPicInfoView{
    //  int options = 1;
    //  int height = optionHeight * options;
    int infoViewWidth = 550;
    int infoViewHeight = 355;
    
    //Bar image
    self.hiddenInfoPicFrame = CGRectMake(0 - infoViewWidth, 60, infoViewWidth, infoViewHeight);
    self.shownInfoPicFrame = CGRectMake(0 -radius , 60, infoViewWidth, infoViewHeight);
    self.infoPicView.frame = self.hiddenInfoPicFrame;
    
    self.infoPicView.layer.cornerRadius = radius;
    self.infoPicView.clipsToBounds = YES;
    
    self.infoPicImg.image = [UIImage imageNamed:@"infoBg2.png"];

    [self.view bringSubviewToFront:self.infoPicView];
    
}

-(void)initFilterListView{
    
    
    CGRect v = self.filtersView.frame;
    
    self.hiddenFiltersFrame = CGRectMake(0 - v.size.width, v.origin.y, v.size.width, v.size.height);
    self.shownFiltersFrame = CGRectMake(0 - radius, v.origin.y, v.size.width, v.size.height);
    self.filtersView.frame = self.hiddenFiltersFrame;
    
    self.filtersView.layer.cornerRadius = radius;
    self.filtersView.clipsToBounds = YES;
    
    [self.view bringSubviewToFront:self.filtersView];
}

-(void)initFilterDetailView{
    int buttonRadius = 5;
    
    CGRect v = self.filterDetailView.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.hiddenFilterDetailFrame = CGRectMake(v.origin.x, screenRect.size.height, v.size.width, v.size.height);
    self.shownFilterDetailFrame = CGRectMake(v.origin.x, screenRect.size.height - 57 - v.size.height, v.size.width, v.size.height);
    self.filterDetailView.frame = self.hiddenFilterDetailFrame;
    
    self.filterDetailView.layer.cornerRadius = radius;
    self.filterDetailView.clipsToBounds = YES;
    
    self.filterDetailTitleTextLbl = NSLocalizedString(@"FILTER", nil);
    
    [self.filterDetailSaveBtn setTitle: NSLocalizedString(@"SAVE_CHANGES", nil) forState: UIControlStateNormal];
    [self.filterDetailCopyBtn setTitle: NSLocalizedString(@"SAVE_COPY", nil) forState: UIControlStateNormal];
    [self.filterDetailCancelBtn setTitle: NSLocalizedString(@"CANCEL", nil) forState: UIControlStateNormal];
    
    self.filterDetailSaveBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailCopyBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailCancelBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailSaveBtn.clipsToBounds = YES;
    self.filterDetailCopyBtn.clipsToBounds = YES;
    self.filterDetailCancelBtn.clipsToBounds = YES;
    
    
    [self.view bringSubviewToFront:self.filterDetailView];
}


-(void)initDebugControls{
    
    self.debugButton.hidden = false;
  
}

-(void)switchOptions{
    if(isOnePicView){
        [self switchOnePicOptions];
    }
    else{
        [self switchAlbumOptions];
    }
}

-(void)switchAlbumOptions
{
    if(isShowingAlbumOptions){
        [self hideAlbumOptions];
    }
    else{
        [self showAlbumOptions];
    }
}



-(void)switchOnePicOptions
{
    if(isShowingPicOptions){
        [UIView animateWithDuration:hideViewDuration animations:^{ self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;}];
        isShowingPicOptions = false;
    }
    else{
        self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;
        [UIView animateWithDuration:showViewDuration animations:^{ self.optionsOnePicView.frame = self.shownOnePicOptionsFrame;}];
        isShowingPicOptions = true;
    }
}





-(void)switchAlbumInfoView
{
    if(isShownAlbumInfo){
        [self hideAlbumInfo];
    }
    else{
        [self showAlbumInfo];
    }
}



-(void)switchFiltersView
{
    if(isShownFilters){
        [self hideFilters];
    }
    else{
        [self showFilters];
    }
}

-(void)showAlbumOptions
{
    self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;
    [UIView animateWithDuration:0.07 animations:^{ self.optionsAlbumView.frame = self.shownAlbumOptionsFrame;}];
    isShowingAlbumOptions = true;
    
}

-(void)hideAlbumOptions
{
    [UIView animateWithDuration:0.1 animations:^{ self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;}];
    isShowingAlbumOptions = false;
}


-(void)showAlbumInfo{
    //[UIView animateWithDuration:0.07 animations:^{ self.infoAlbumView.frame = self.shownInfoAlbumFrame;}];
    
    self.titleLbl.text = NSLocalizedString(@"SINGLE_ALBUM_TITLE", nil);
    self.numPicsTextLbl.text = NSLocalizedString(@"ALBUM_NUM_PICS", nil);
    self.numPicsLbl.text = [NSString stringWithFormat: @"%d", self.picsArray.count];
    self.numPicsView.hidden = false;
    self.headerView.hidden = false;
    self.backButtonView.hidden = true;
    
    [self refitAlbumHeader];
    
    isShownAlbumInfo = true;
    [self hideAlbumOptions];
    UIImage * btnImage = [UIImage imageNamed:@"info_s.png"];
	[self.AlbumOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
}

-(void)hideAlbumInfo
{
    self.headerView.hidden = true;
    isShownAlbumInfo = false;
    [self hideAlbumOptions];
    UIImage * btnImage = [UIImage imageNamed:@"info.png"];
	[self.AlbumOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    //[UIView animateWithDuration:0.1 animations:^{ self.infoAlbumView.frame = self.hiddenInfoAlbumFrame;}];
}




-(void)switchPicInfoView
{
    if(isShownPicInfo){
        [self hidePicInfo];
    }
    else{
        [self showPicInfo];
    }
}

-(void)showPicInfo{
    UIImage * btnImage = [UIImage imageNamed:@"info_s.png"];
	[self.OnePicOptionsBtn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    self.nameTextLbl.text = NSLocalizedString(@"PIC_NAME", nil);
    self.nameLbl.text = self.pickedPic.name;
    
    self.albumLbl.text = NSLocalizedString(@"SINGLE_ALBUM_TITLE", nil);
    
    
    CLLocation * selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[self.pickedPic.latitude doubleValue]
                                                             longitude:(CLLocationDegrees)[self.pickedPic.longitude doubleValue]];
    
    [self getReverseGeocodeLocation:selectedLocation];
    [self setReverseGeocodeLocation ];
    
    [UIView animateWithDuration:showViewDuration  animations:^{ self.infoPicView.frame = self.shownInfoPicFrame;}];
    isShownPicInfo = true;
    //[self switchOnePicOptions];
}

-(void)hidePicInfo
{
    UIImage * btnImage = [UIImage imageNamed:@"info.png"];
	[self.OnePicOptionsBtn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [UIView animateWithDuration:hideViewDuration animations:^{ self.infoPicView.frame = self.hiddenInfoPicFrame;}];
    isShownPicInfo = false;

}


-(void)showFilters
{
    [UIView animateWithDuration:showViewDuration animations:^{ self.filtersView.frame = self.shownFiltersFrame;}];
    isShownFilters = true;
    
    UIImage * btnImage = [UIImage imageNamed:@"filter_s.png"];
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    if(self.lastPickedImg != self.pickedImg){
        [self.filtersCollectionView reloadData];
        self.lastPickedImg = self.pickedImg;
    }
}

-(void)showFilterDetail:(NSString *)filterName
{
    self.filterDetailTitleLbl.text = filterName;
    [UIView animateWithDuration:showViewDuration animations:^{ self.filterDetailView.frame = self.shownFilterDetailFrame;}];
    isShownFilterDetail = true;
}

-(void)hideFilterDetail
{
    [UIView animateWithDuration:showViewDuration animations:^{ self.filterDetailView.frame = self.hiddenFilterDetailFrame;}];
    isShownFilterDetail = false;
}


-(void)hideFilters
{

    [UIView animateWithDuration:hideViewDuration animations:^{ self.filtersView.frame = self.hiddenFiltersFrame;}];
    isShownFilters = false;
    UIImage * btnImage = [UIImage imageNamed:@"filter.png"];
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    
}


-(void)toFilters{
    
    [self switchFiltersView];
    
}

-(void)showFilter:(NSNumber *)filterId{
    
    switch ([filterId integerValue]) {
        case 1:
            
            break;
            
        default:
            break;
    }
    
}

-(void)switchFaces
{
    if(isShownFaces){
        [self hideFaces];
    }
    else{
        [self showFaces];
    }
}

-(void)showFaces{
    isShownFaces = true;
    UIImage * btnImage = [UIImage imageNamed:@"face_s.png"];
    [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(void)hideFaces
{
    
    //[UIView animateWithDuration:hideViewDuration animations:^{ self.filtersView.frame = self.hiddenFiltersFrame;}];
    isShownFaces = false;
    UIImage * btnImage = [UIImage imageNamed:@"face.png"];
    [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    
}

-(void)toShare{
    UIActivityViewController * controller = [[UIActivityViewController alloc]initWithActivityItems:@[self.pickedImg] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)saveFilterImg:(id)sender {
    [[YVHUtil getInstance] saveImage:self.PicViewImg.image currentPic:self.pickedPic isNewImage:NO];
    [[YVHCoreDataStack getInstance] saveContext];
    self.pickedImg = self.PicViewImg.image;
    [self voidScreen];
}

- (IBAction)saveFilterNewImg:(id)sender {
}

- (IBAction)cancelFilter:(id)sender {
    [self hideFilterDetail];
    self.PicViewImg.image = self.pickedImg;
}

- (IBAction)prevFilter:(id)sender {
    if (self.pickedFilter == 0) {
        self.pickedFilter = self.filterList.count -1;
    }else{
        self.pickedFilter -= 1;
    }
    
    NSString * filter = [self.filterList objectAtIndex:self.pickedFilter];
    UIImage * photo = self.pickedImg;
    UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
    self.PicViewImg.image = fphoto;
    
    [self showFilterDetail:filter];
    
}
- (IBAction)postFilter:(id)sender {
    if (self.pickedFilter == self.filterList.count -1) {
        self.pickedFilter = 0;
    }else{
        self.pickedFilter += 1;
    }
    
    NSString * filter = [self.filterList objectAtIndex:self.pickedFilter];
    UIImage * photo = self.pickedImg;
    UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
    self.PicViewImg.image = fphoto;
    
    [self showFilterDetail:filter];
}

-(void)voidScreen{
    if(isShowingPicOptions){
        [self switchOnePicOptions];
    }
    
    if(isShownPicInfo){
        [self hidePicInfo];
    }
    
    if(isShownFilters){
        [self hideFilters];
    }
    
    if (isShownFilterDetail) {
        [self hideFilterDetail];
    }

}


#pragma mark -
#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int n;
    
    if (collectionView == self.collectionView) {
        n = [self.picsArray count];
    }
    else{
        n = self.filterList.count;
    }
    return n;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        // Setup cell identifier
        static NSString *cellIdentifier = @"cvCell";
        
        CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        
        NSInteger x = indexPath.row;
        
        if(x<[self.picsArray count]){
            Pic * data = [self.picsArray objectAtIndex:x];
            UIImage *photo = [self getThumnailFromDisk:data.path];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.image.image = photo;
        }
        
        
        // Return the cell
        return cell;
    }
    else{ // if (collectionView == self.filtersCollectionView){
        
        FilterCell *cell = (FilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
        

        
        int x = indexPath.row;
        
        if(x<[self.filterList count]){
            
            
            if(isOnePicView){
                NSString * filter = [self.filterList objectAtIndex:x];
                UIImage * photo = self.pickedImg;
                UIImage * thumb = [self getThumnailFromUImage:photo];
                UIImage * fthumb = [self standarFilterToImage:thumb filterName:filter];
                cell.image.image = fthumb;
            }

        }
        
        
        // Return the cell
        return cell;
    }
    

    
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collectionView) {
        NSInteger x = indexPath.row;
        NSInteger y = indexPath.section;
        NSInteger i = x + (y * 3);
        if(i<[self.picsArray count]){
            
            self.lastPickedImg = self.pickedImg;
            self.pickedPic = [self.picsArray objectAtIndex:x];
            
            self.pickedImg = [self getPicFromDisk:self.pickedPic.path];
            self.PicViewImg.image = self.pickedImg;
            self.PicView.hidden = false;
            self.collectionView.hidden = true;
            
            isStatusBarHidden = true;
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
            {
                [self setNeedsStatusBarAppearanceUpdate];
            }
            
            [YVHDAO setSelectedPics:@[self.pickedPic]];
            self.titleLbl.text = self.pickedPic.name;
        }
        
        self.infoPicView.hidden = false;
        self.headerView.hidden = false;
        self.numPicsView.hidden = true;
        self.backButtonView.hidden = false;
        
        if(isShowingAlbumOptions){
            [self hideAlbumOptions];
        }
        if(isShownPicInfo){
            [self showPicInfo];
        }
        isOnePicView = true;
    }
    else{// Filters collection
        
        int x = indexPath.row;
        
        if(x<[self.filterList count]){
            
            NSString * filter = [self.filterList objectAtIndex:x];
            UIImage * photo = self.pickedImg;
            UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
            self.PicViewImg.image = fphoto;
            
            [self showFilterDetail:filter];
            self.pickedFilter = (NSInteger)x;
            
        }
    }
    
}
- (BOOL)prefersStatusBarHidden
{
    return isStatusBarHidden;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
}


#pragma mark -
#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        
        Pic *data = self.picsArray[indexPath.row];
        UIImage *photo = [self getPicFromDisk:data.path];
        // 2
        CGSize retval = photo.size.width > 0 ? [self reducePicCell:photo.size] : CGSizeMake(100, 100);
        //CGSize retval = CGSizeMake(100, 100);
        retval.height += 35; retval.width += 35;
        return retval;
    }
    else{

        CGSize retval =  CGSizeMake(200, 180);
        //CGSize retval = CGSizeMake(100, 100);
        return retval;
    }
}

-(CGSize)reducePicCell:(CGSize)sz{
    int w, h, ws, hs ;
    w = sz.width;
    h = sz.height;
    if(w > h ){
        ws = 200;
        hs = h*ws/w;
    }
    else{
        hs = 200;
        ws = w*hs/h;
    }
    
    return CGSizeMake(ws, hs);

}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //Es el espacio entre las celdas y collection container
    return UIEdgeInsetsMake(20, 20, 20, 20);
}



@end
