//
//  Helper.swift
//  TestApp
//
//  Created by Rahul Sharma on 19/03/21.
//



import UIKit


class Helper: NSObject {
    
    static var newAlertWindow:UIWindow? = nil
    
  
    class func push(fromVc:UIViewController!,toVcidentifier:String!){
        
        let viewController = fromVc.storyboard?.instantiateViewController(withIdentifier: toVcidentifier)
        fromVc.navigationController?.pushViewController(viewController!, animated: true)
    }
    //AlertView
    class func alertVC(title:String, message:String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        sender.present(alert, animated: true, completion: nil)
    }

    
    /// Method to change Image frame
    ///
    /// - Parameters:
    ///   - image: input image to change frame
    ///   - newSize: new size of image
    /// - Returns: new size updated image
    class func changeImageFrame(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.5)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }

    
    
    /// Method to resize the image
    ///
    /// - Parameters:
    ///   - image: input image
    ///   - newSize: custom size user want to change
    /// - Returns: resized output image
    class func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.5)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }

    class func intForObj(object: Any?) -> Int {
        
        switch object {
            
        case is Int, is Int8, is Int16, is Int32, is Int64:
            
            return object as! Int
            
        case is String:
            
            if (object as! String) == "" {
                return 0
            }
            return Int(object as! String)!
            
        default:
            
            return 0
        }
    }

    class func strForObj(object: Any?) -> String {
        
        switch object {
            
        case is String: // String
            
            switch object as! String {
                
            case "(null)", "(Null)", "<null>", "<Null>":
                
                return ""
                
            default:
                
                return String(format:"%@",object as! String)
            }
            
        case is Int, is Float, is Double, is Int64:
            
            return String(format:"%@",object as! CVarArg)
            
        default:
            
            return ""
        }
    }
    
}

