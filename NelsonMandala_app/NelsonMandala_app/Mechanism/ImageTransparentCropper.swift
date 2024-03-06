//
//  ImageTransparentCropper.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 13/12/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation
import UIKit

class ImageTransparentCropper {
    
    
    func CropImage(imageToCrop: UIImage) -> UIImage {
        
        let pixelInfoArray = self.pixelArrayFromImage(image: imageToCrop)
        var exitPixelArray: [[PixelData]] = []

//        //Adiciona as linhas preenchidas no novo matrix de cores
//        for y in 0 ..< pixelInfoArray.count {
//            var filledCount: Int = 0
//            for x in 0 ..< pixelInfoArray[0].count {
//                if(pixelInfoArray[x][y].a > 0)
//                {
//                    filledCount += 1
//                }
//            }
//            if filledCount > 0 {
//                exitPixelArray.append(pixelInfoArray[y])
//            }
//        }
//
//        //Remove colunas vazias do novo matrix de cores
//        for y in 0 ..< exitPixelArray.count {
//            var fillCount: Int = 0
//            for x in 0 ..< exitPixelArray[0].count {
//                if(exitPixelArray[y][x].a > 0)
//                {
//                    fillCount += 1
//                }
//            }
//            if fillCount > 0{
//                //remove essa coluna
//                for x in 0 ..< exitPixelArray.count {
//                    exitPixelArray[x].remove(at: y)
//                }
//            }
//        }
        
        //return createImageFromColorMatrix(colorMatrix: exitPixelArray)
        return createImageFromColorMatrix(colorMatrix: pixelInfoArray)
    }
    
    fileprivate func pixelArrayFromImage(image: UIImage) -> [[PixelData]] {
        
        let imageWidthPixelCount = image.cgImage!.width
        let imageHeightPixelCount = image.cgImage!.height
        
        var dataMatrix: [[PixelData]] = []
        
        for x in 0..<imageWidthPixelCount {
            dataMatrix.append([])
            for y in 0..<imageHeightPixelCount {
                let color = getPixelColor(image: image, pos: CGPoint.init(x: x, y: y))
                dataMatrix[x].append(color)
            }
        }
        
        return dataMatrix
    }
    
    fileprivate func getPixelColor(image: UIImage, pos: CGPoint) -> PixelData {
        let cgImage = image.cgImage!
        //let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage)!)
        let pixelData = cgImage.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = data[pixelInfo]
        let g = data[pixelInfo+1]
        let b = data[pixelInfo+2]
        let a = data[pixelInfo+3]
        
        if(r != 0 || g != 0 || b != 0 || a != 0) {
            print("R \(r) - G \(g) - B \(b) - A \(a)")
        }
        
        
        return PixelData(a: a, r: r, g: g, b: b)
    }
    
    fileprivate func createImageFromColorMatrix(colorMatrix :[[PixelData]]) -> UIImage {

        var dataInArray: [PixelData] = []
        for y in 0 ..< colorMatrix.count {
            for x in 0 ..< colorMatrix[0].count {
                dataInArray.append(colorMatrix[y][x])
            }
        }
        
        return imageFromBitmap(pixels: dataInArray, width: colorMatrix[0].count, height: colorMatrix.count)!
    }
    
    fileprivate struct PixelData {
        var a: UInt8 = 0
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0
    }
    
    fileprivate func imageFromBitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        assert(width > 0)
        
        assert(height > 0)
        
        let pixelDataSize = MemoryLayout<PixelData>.size
        assert(pixelDataSize == 4)
        
        assert(pixels.count == Int(width * height))
        
        let data: Data = pixels.withUnsafeBufferPointer {
            return Data(buffer: $0)
        }
        
        let cfdata = NSData(data: data) as CFData
        let provider: CGDataProvider! = CGDataProvider(data: cfdata)
        if provider == nil {
            print("CGDataProvider is not supposed to be nil")
            return nil
        }
        let cgimage: CGImage! = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * pixelDataSize,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        if cgimage == nil {
            print("CGImage is not supposed to be nil")
            return nil
        }
        print("tamanho da imagem final: \(width) / \(height)")
        return UIImage(cgImage: cgimage)
    }
    
    
    
    
    
}

