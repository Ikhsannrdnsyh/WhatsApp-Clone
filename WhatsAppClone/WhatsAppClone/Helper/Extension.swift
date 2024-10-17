//
//  Extension.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/10/24.
//

import Foundation
import UIKit

extension Date {
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return Float(start - end)
    }
}

extension UIImage{
    var isLandscape: Bool { return size.width > size.height}
    var isPotrait: Bool { return size.width < size.height}
    var breadth: CGFloat{ return min(size.width, size.height)}
    var breadthSize: CGSize{ return CGSize(width: breadth, height: breadth)}
    var breadthRect: CGRect{ return CGRect(origin: .zero, size: breadthSize)}
    
    var circleMasked: UIImage?{
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer{
            UIGraphicsEndImageContext()
        }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPotrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
