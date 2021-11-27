 //
//  UITextFieldExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/5/16.
//  Copyright © 2016 SwifterSwift
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

private var kAssociationKeyMaxLength: Int = 0

var INZMaxLengthKey         = "INZMaxLengthKey"
var INZAllowCharacterKey    = "INZAllowCharacterKey"
var INZDisAllowCharacterKey = "INZDisAllowCharacterKey"

// MARK: - Enums
public extension UITextField {

    /// SwifterSwift: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    enum TextType {
        /// UITextField is used to enter email addresses.
        case emailAddress

        /// UITextField is used to enter passwords.
        case password

        /// UITextField is used to enter generic text.
        case generic
    }

}

// MARK: - Properties
public extension UITextField {

    func addTextChangeTarget() {
        self.removeTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
    }
    
    @objc func textFieldTextChanged(textField : UITextField) -> Void {
        if  allowCharacter != nil {
            let allowCharSet = NSCharacterSet(charactersIn: allowCharacter!) as CharacterSet
            let disAllowCharSet = NSCharacterSet(charactersIn: allowCharacter!).inverted as CharacterSet
            if self.text?.rangeOfCharacter(from: allowCharSet) == nil {
                textField.text = textField.text?.trimmingCharacters(in: disAllowCharSet)
            }
            else if self.text?.rangeOfCharacter(from: disAllowCharSet) != nil {
                textField.text = textField.text?.trimmingCharacters(in: disAllowCharSet)
            }
            
        }else if disAllowCharacter != nil {
            let disAllowCharSet = CharacterSet(charactersIn: disAllowCharacter!)
            if self.text?.rangeOfCharacter(from: disAllowCharSet) != nil {
                textField.text = textField.text?.trimmingCharacters(in: disAllowCharSet)
            }
        }
        let adaptedLength = min((self.text?.length)!, self.maxLength)
        let index = self.text?.index((self.text?.startIndex)!, offsetBy: adaptedLength)
        self.text =  String((self.text?[..<index!])!)  //String(str[..<index]) //self.text?.substring(to: index!)
    }
    
    
    /// SwifterSwift: Set textField for common text types.
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                placeholder = "Email Address"

            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                placeholder = "Password"

            case .generic:
                isSecureTextEntry = false
            }
        }
    }

    /// SwifterSwift: Check if text field is empty.
    var isEmpty: Bool {
        return text?.isEmpty == true
    }

    /// SwifterSwift: Return text with no spaces or new lines in beginning and end.
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// SwifterSwift: Check if textFields text is a valid email format.
    ///
    ///		textField.text = "john@doe.com"
    ///		textField.hasValidEmail -> true
    ///
    ///		textField.text = "swifterswift"
    ///		textField.hasValidEmail -> false
    ///
    var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }

    /// SwifterSwift: Left view tint color.
    @IBInspectable var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

    /// SwifterSwift: Right view tint color.
    @IBInspectable var rightViewTintColor: UIColor? {
        get {
            guard let iconView = rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

    @IBInspectable var allowCharacter : String?  {
        get {
            return objc_getAssociatedObject(self, &INZAllowCharacterKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &INZAllowCharacterKey, (newValue?.lowercased())!+(newValue?.uppercased())!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTextChangeTarget()
        }
    }
    
    @IBInspectable var disAllowCharacter : String?  {
        get {
            return objc_getAssociatedObject(self, &INZDisAllowCharacterKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &INZDisAllowCharacterKey, (newValue?.lowercased())!+(newValue?.uppercased())!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTextChangeTarget()
        }
    }
    
    @IBInspectable var maxLength : Int  {
        get {
            return objc_getAssociatedObject(self, &INZMaxLengthKey) as? Int ?? Int(INT_MAX)
        }
        set {
            objc_setAssociatedObject(self, &INZMaxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTextChangeTarget()
        }
    }


}

// MARK: - Methods
public extension UITextField {

    /// SwifterSwift: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// SwifterSwift: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }

    /// SwifterSwift: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }

    /// SwifterSwift: Add padding to the left of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextField.ViewMode.always
    }

}

#endif
