/*
 - Project: Cartool
 - File: bridge.h
 - Author: Levi Dhuyvetter
 - Date: 03/12/2018
 - Copyright: © 2018 Levi Dhuyvetter
 - License: MIT
 */

#import <Foundation/Foundation.h>

//Objective-C bridging header for the CoreUI private framework.

typedef enum _kCoreThemeIdiom {
	kCoreThemeIdiomUniversal,
	kCoreThemeIdiomPhone,
	kCoreThemeIdiomPad,
	kCoreThemeIdiomTV,
	kCoreThemeIdiomCar,
	kCoreThemeIdiomWatch,
	kCoreThemeIdiomMarketing
} kCoreThemeIdiom;

typedef NS_ENUM(NSInteger, UIUserInterfaceSizeClass) {
	UIUserInterfaceSizeClassUnspecified = 0,
	UIUserInterfaceSizeClassCompact     = 1,
	UIUserInterfaceSizeClassRegular     = 2,
};

@interface CUICommonAssetStorage : NSObject

-(NSArray *)allAssetKeys;
-(NSArray *)allRenditionNames;

-(id)initWithPath:(NSString *)p;

-(NSString *)versionString;

@end

@interface CUINamedImage : NSObject

@property(readonly) CGSize size;
@property(readonly) CGFloat scale;
@property(readonly) kCoreThemeIdiom idiom;
@property(readonly) UIUserInterfaceSizeClass sizeClassHorizontal;
@property(readonly) UIUserInterfaceSizeClass sizeClassVertical;

-(CGImageRef)image;

@end

@interface CUIRenditionKey : NSObject
@end

@interface CUIThemeFacet : NSObject

+(CUIThemeFacet *)themeWithContentsOfURL:(NSURL *)u error:(NSError **)e;

@end

@interface CUICatalog : NSObject

@property(readonly) bool isVectorBased;

-(id)initWithURL:(NSURL *)URL error:(NSError **)error;
-(id)initWithName:(NSString *)n fromBundle:(NSBundle *)b;
-(id)allKeys;
-(id)allImageNames;
-(CUINamedImage *)imageWithName:(NSString *)n scaleFactor:(CGFloat)s;
-(CUINamedImage *)imageWithName:(NSString *)n scaleFactor:(CGFloat)s deviceIdiom:(int)idiom;
-(NSArray *)imagesWithName:(NSString *)n;

@end
