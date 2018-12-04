/*
- Project: Cartool
- File: functions.swift
- Author: Levi Dhuyvetter
- Date: 03/12/2018
- Copyright: © 2018 Levi Dhuyvetter
- License: MIT
*/

import Foundation
import AppKit

/**
Saves a `CGImage` to a PNG file at the specified `URL`.

- Parameter image: The image to be saved as `CGImage`.
- Parameter url: The location where to save the image as `URL`.
- Returns: Boolean indicating if the operation succeeded.
*/
func save(image:CGImage, to url:URL) -> Bool {
	let bitmap = NSBitmapImageRep(cgImage: image)
	
	if let data = bitmap.representation(using: .png, properties: [:]) {
		do {
			try data.write(to: url, options: .atomic)
			return true
		} catch {
			return false
		}
	} else {
		return false
	}
}

/**
Returns a suffix for a given `CGImage` idiom.

- Parameter idiom: Idiom as `kCoreThemeIdiom` enum.
- Returns: Suffix as `String`.
*/
func suffix(for idiom:kCoreThemeIdiom) -> String {
	switch idiom {
	case kCoreThemeIdiomUniversal:
		return ""
		
	case kCoreThemeIdiomPhone:
		return "~iphone"
		
	case kCoreThemeIdiomPad:
		return "~ipad"
		
	case kCoreThemeIdiomTV:
		return "~tv"
		
	case kCoreThemeIdiomCar:
		return "~carplay"
		
	case kCoreThemeIdiomWatch:
		return "~watch"
		
	case kCoreThemeIdiomMarketing:
		return "~marketing"
		
	default:
		return ""
	}
}

/**
Returns a suffix for a given `CGImage` sizeClass.

- Parameter sizeClass: Size class as `UIUserInterfaceSizeClass`.
- Returns: Suffix as `String`.
*/
func suffix(for sizeClass:UIUserInterfaceSizeClass) -> String {
	switch sizeClass {
	case .unspecified:
		return "A"
		
	case .compact:
		return "C"
		
	case .regular:
		return "R"
	}
}

/**
Returns array of `CUINamedImage` instances for a given name in a given catalog.

- Parameter catalog: The catalog containing the images named as `CUICatalog`.
- Parameter name: The name of the images as `String`.
- Returns: An array of `CUINamedImage` instances for each scale factor.
*/
func getImages(from catalog:CUICatalog, for name:String) -> [CUINamedImage] {
	var images:[CUINamedImage] = []
	
	for scaleFactor in 1...3 {
		let image = catalog.image(withName: name, scaleFactor: CGFloat(scaleFactor))
		if let image = image, image.scale == CGFloat(scaleFactor) { images.append(image) }
	}
	
	return images
}

/**
Exports the contents of a given .car file to images in a given directory. Will create subdirectories for any resources with sub paths.

- Parameter carFile: A file URL as `URL`
- Parameter directory: A file URL indicating the directory as `URL`
*/
func export(carFile:URL, to directory:URL) {
	do {
		let catalog = try CUICatalog.init(url: carFile)
		let storage = CUICommonAssetStorage.init(path: carFile.path)
		
		for name in (storage?.allRenditionNames() ?? []) as! [String] {
			print("Exporting rendition \"\(name)\":")
			
			if let pathComponents = URL(string: name)?.pathComponents, pathComponents.count > 1 {
				var subDirectory = directory
				
				for pathComponent in pathComponents {
					subDirectory.appendPathComponent(pathComponent)
				}
				
				try FileManager.default.createDirectory(at: subDirectory, withIntermediateDirectories: true, attributes: nil)
			}
			
			let images = getImages(from: catalog, for: name)
			
			for image in images {
				if image.size.width == 0, image.size.height == 0 {
					print("\tFailed: rendition is nil.")
				} else {
					if let cgImage = image.image()?.takeUnretainedValue() {
						let idiomSuffix = suffix(for: image.idiom)
						let sizeClassSuffix = "-\(suffix(for: image.sizeClassHorizontal))x\(suffix(for: image.sizeClassVertical))"
						let scale = image.scale > 1.0 ? "@\(Int(image.scale))x" : ""
						let fileName = "\(name)\(idiomSuffix)\(sizeClassSuffix)\(scale).png"
						print("\tCreated \"\(fileName)\".")
						
						if save(image: cgImage, to: directory.appendingPathComponent(fileName)) {
							print("\tSaved \"\(fileName)\".")
						} else {
							print("\tFailed: could not save \"\(fileName)\".")
						}
					} else {
						print("\tFailed: could not convert rendition to CGImage")
					}
				}
			}
		}
	} catch {
		print("Quit with error: \(error.localizedDescription)")
	}
}
