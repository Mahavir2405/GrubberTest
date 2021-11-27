//
//  UIButton+ActivityIndicator.swift
//  WebClient-Swift
//
//  
//
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

extension UIButton {
    
    func setImageWithURL(strUrl: String, activityIndicatorViewStyle: UIActivityIndicatorView.Style, controlState: UIControl.State) {
        setImageWithURL(strUrl: strUrl, placeHolderImage: nil, activityIndicatorViewStyle: activityIndicatorViewStyle, controlState:controlState)
    }
    
    func setImageWithURL(strUrl: String, placeHolderImage placeholderImage: UIImage?, activityIndicatorViewStyle: UIActivityIndicatorView.Style, controlState: UIControl.State) {
        setImageWithURL(strUrl: strUrl, placeHolderImage: placeholderImage, activityIndicatorViewStyle: activityIndicatorViewStyle, controlState: controlState, completionBlock: nil)
    }
    
    func setImageWithURL(strUrl: String, placeHolderImage placeholderImage: UIImage?, activityIndicatorViewStyle: UIActivityIndicatorView.Style, controlState: UIControl.State, completionBlock:((_ image: UIImage?, _ error: Error?) -> Void)?) {
        Alamofire.AF.request(strUrl).responseImage { response in
            let image = response
            if let data = image.data {
                self.addActivityIndicator(activityStyle: activityIndicatorViewStyle)
                self.setImage(UIImage(data: data), for: controlState)
                self.removeActivityIndicator()
                completionBlock?(UIImage(data: data), nil)
            }
            else {
                self.removeActivityIndicator()
                completionBlock?(nil, response.error)
            }
        }
    }
    
    func addActivityIndicator(activityStyle: UIActivityIndicatorView.Style) {
        var activityIndicator = self.viewWithTag(TAG_ACTIVITY_INDICATOR) as? UIActivityIndicatorView
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: activityStyle)
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
