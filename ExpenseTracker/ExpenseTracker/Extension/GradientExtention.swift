//
//  GradientExtention.swift
//  Coupon
//
//  Created by Macmini_1 on 17/11/18.
//

import UIKit

@IBDesignable open class GradientButton: UIButton {
    
    @IBInspectable open var firstColor: UIColor = .black {
        didSet {
            applyGradientEffect()
        }
    }
    @IBInspectable open var secondColor: UIColor = .white {
        didSet {
            applyGradientEffect()
        }
    }
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            applyGradientEffect()
        }
    }
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
 
    //MARK: -
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradientEffect()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradientEffect()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradientEffect()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        applyGradientEffect()
    }
    
    //MARK: -
    
    func applyGradientEffect() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = vertical ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = vertical ? CGPoint(x: 0.5, y: 1) : CGPoint(x: 1, y: 0.5)
    }
}


@IBDesignable open class GradientView: UIView {
    
    @IBInspectable open var firstColor: UIColor = UIColor.black {
        didSet {
            applyGradientEffect()
        }
    }
    @IBInspectable open var secondColor: UIColor = UIColor.white {
        didSet {
            applyGradientEffect()
        }
    }
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            applyGradientEffect()
        }
    }
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    //MARK: -
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradientEffect()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradientEffect()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradientEffect()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        applyGradientEffect()
    }
    
    //MARK: -
    
    func applyGradientEffect() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            updateGradientDirection()
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradientEffect()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradientEffect()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradientEffect()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradientEffect() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class RadialGradientView: UIView {
    
    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyGradientEffect()
    }
    
    func applyGradientEffect() {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        #if TARGET_INTERFACE_BUILDER
        applyGradientEffect()
        #endif
    }
}

