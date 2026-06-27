//
//  Image+transparency.swift
//  CoffeeShop
//
//  Created by Henrik on 11/06/2026.
//
import SwiftUI
import WidgetKit
import CoreImage.CIFilterBuiltins

extension UIImage {
    func transparency(
        renderingMode: WidgetRenderingMode,
        minimumOpacity: CGFloat = 0.2,
        context: CIContext = CIContext()
    ) -> UIImage? {
        guard renderingMode == .accented else {
            return self
        }
        
        return self
            .grayscale(context: context)?
            .remapGrayscale(min: minimumOpacity, context: context)?
            .grayscaleToAlpha(context: context)
    }
}

extension UIImage {
    func grayscale(context: CIContext) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 0
        
        guard
            let output = filter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent)
        else { return nil }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func remapGrayscale(min: CGFloat, context: CIContext) -> UIImage? {
        guard let ciImage = CIImage(image: self),
              let remapped = ciImage.remapGrayscale(min: min),
              let cgImage = context.createCGImage(remapped, from: remapped.extent)
        else { return nil }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func grayscaleToAlpha(context: CIContext) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter.maskToAlpha()
        filter.inputImage = ciImage
        
        guard
            let output = filter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent)
        else { return nil }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}

extension CIImage {
    func remapGrayscale(min: CGFloat) -> CIImage? {
        let scale = 1 - min
        
        let filter = CIFilter.colorMatrix()
        filter.inputImage = self
        
        filter.rVector = CIVector(x: scale, y: 0, z: 0, w: 0)
        filter.gVector = CIVector(x: 0, y: scale, z: 0, w: 0)
        filter.bVector = CIVector(x: 0, y: 0, z: scale, w: 0)
        filter.biasVector = CIVector(x: min, y: min, z: min, w: 0)
        
        return filter.outputImage
    }
}

@MainActor extension ImageResource {
    var asUIImage: UIImage? {
        let image = Image(self)
        let renderer = ImageRenderer(content: image)
        renderer.scale = 1.0 // Ensure high quality
        return renderer.uiImage
    }
}
