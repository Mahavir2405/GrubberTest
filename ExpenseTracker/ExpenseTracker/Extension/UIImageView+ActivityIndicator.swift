
//
//  UIImageView+ActivityIndicator.swift
//  WebClient-Swift
//
//
//
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

var TAG_ACTIVITY_INDICATOR = 156456

public enum ActivityIndicatorViewStyle : Int {

    case whiteLarge

    case white

    case gray

    case none
}

private let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    //Working
    func cacheImage(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        
        image = nil
        
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let _ = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data!) {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }
                }
            }
            }.resume()
    }

    
    
    
    func imageFromCache(strURL : String?) -> UIImage? {
        if strURL != nil {
            let path = cacheDirectoryPath + "/" + (strURL?.lastPathComponent)!
            if FileManager.default.fileExists(atPath: path) {
                return UIImage(contentsOfFile: path)
            }
        }
        return nil
    }

    func cacheImage(strURL : String, image : UIImage?) -> Void {
        if image != nil {
            if let data : Data = image?.jpegData(compressionQuality: 1) {
                let path = cacheDirectoryPath + "/" + (strURL.lastPathComponent)
                do {
                    try data.write(to: URL(string: path)!, options: .atomic)  //(to: URL(string: path)!, options: true)
                }
                catch {
                    
                }
                
            }
        }
    }

    func setImageWithURL(strUrl: String?, thumbUrl: String? = nil, placeHolderImage: UIImage? = nil, activityIndicatorViewStyle: ActivityIndicatorViewStyle? = .gray) {
        setImageWithURL(strUrl, thumbUrl: thumbUrl, placeHolderImage: placeHolderImage, activityIndicatorViewStyle: activityIndicatorViewStyle, completionBlock: nil)
    }

    func setImageWithURL(_ strUrl: String?,thumbUrl: String?, placeHolderImage: UIImage?, activityIndicatorViewStyle: ActivityIndicatorViewStyle?, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)?) {
        self.image = placeHolderImage

        if let thumb = thumbUrl, thumb.isValid == true, let imageFromCache = imageCache.object(forKey: thumbUrl as AnyObject) as? UIImage {
            print("Image: Thumb from Cache")
            self.image = imageFromCache
            completionBlock?(self.image, nil)
            return
        }
        else if let imageFromCache = imageCache.object(forKey: strUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            completionBlock?(self.image, nil)
            return
        }
        else {
            if thumbUrl != nil {
                if activityIndicatorViewStyle != ActivityIndicatorViewStyle.none {
                    self.addActivityIndicator(activityStyle: activityIndicatorViewStyle!)
                }
                
                Alamofire.AF.request(thumbUrl!).responseImage { response in
                    if (response.data?.count ?? 0)! > 0 {
                        
                        if let imageToCache = UIImage(data: response.data!) {
                            DispatchQueue.main.async {
                                imageCache.setObject(imageToCache, forKey: thumbUrl as AnyObject)
                                self.image = imageToCache
                                completionBlock?(imageToCache, nil)
                            }
                            self.removeActivityIndicator()
                        }
                        else {
                            self.setImageOriginalWithURL(strUrl, placeHolderImage: placeHolderImage, completionBlock: { (image, error) in
                                completionBlock?(image, error)
                                self.removeActivityIndicator()
                            })
                        }
                    }
                    else {
                        self.setImageOriginalWithURL(strUrl, placeHolderImage: placeHolderImage, completionBlock: { (image, error) in
                            completionBlock?(image, error)
                            self.removeActivityIndicator()
                        })
                    }
                }
            }
            else {
                self.setImageOriginalWithURL(strUrl, placeHolderImage: placeHolderImage, completionBlock: { (image, error) in
                    completionBlock?(image, error)
                    self.removeActivityIndicator()
                })
            }
        }
    }
    
    func setImageOriginalWithURL(_ strUrl: String?, placeHolderImage: UIImage?, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)?) {
        
        if strUrl != nil {
            Alamofire.AF.request(strUrl!).responseImage { response in
                if (response.data?.count ?? 0)! > 0 {
                    if let imageToCache = UIImage(data: response.data!) {
                        DispatchQueue.main.async {
                            imageCache.setObject(imageToCache, forKey: strUrl! as AnyObject)
                            self.image = imageToCache
                            completionBlock?(imageToCache, nil)
                            self.removeActivityIndicator()
                        }
                    }
                    else {
                        self.image = placeHolderImage
                        completionBlock?(self.image, response.error)
                    }
                }
                else {
                    self.image = placeHolderImage
                    completionBlock?(self.image, response.error)
                }
            }
        }
        else {
            self.image = placeHolderImage
            completionBlock?(self.image, nil)
        }
    }

    func addActivityIndicator(activityStyle: ActivityIndicatorViewStyle) {
        var activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator == nil {
            var indicatiorStyle :  UIActivityIndicatorView.Style = .white
            switch activityStyle {
            case .white:
                indicatiorStyle = .white
                break
            case .whiteLarge:
                indicatiorStyle = .whiteLarge
                break
            case .gray:
                indicatiorStyle = .gray
                break
            default:
                indicatiorStyle = .white

            }
            activityIndicator = UIActivityIndicatorView(style: indicatiorStyle)
            activityIndicator!.center = CGPoint(x: CGFloat(self.frame.size.width / 2), y: CGFloat(self.frame.size.height / 2))
            activityIndicator!.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
            activityIndicator!.hidesWhenStopped = true
            activityIndicator!.tag = TAG_ACTIVITY_INDICATOR
            self.addSubview(activityIndicator!)
        }
        activityIndicator?.startAnimating()
    }

    func removeActivityIndicator() {
        let activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
        }
    }

}

