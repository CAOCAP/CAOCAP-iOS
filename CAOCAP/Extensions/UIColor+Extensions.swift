//
//  UIColor+Extensions.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 28/07/2023.
//

import UIKit
import SwiftUI


// MARK: - UIColor Extension for Hex Conversion
extension UIColor {

    /// Returns the hex string representation of the UIColor.
    ///
    /// This property converts the color's RGB and alpha components into a hexadecimal string,
    /// prefixed by "#". The string format is `#RRGGBB` for opaque colors or `#RRGGBBAA`
    /// for colors with transparency.
    ///
    /// - Note: The color is first converted to the sRGB color space to ensure accurate representation.
    /// - Returns: A hexadecimal string in the format `#RRGGBB` or `#RRGGBBAA` if the color is translucent.
    var hexString: String {
        // Convert the UIColor to the sRGB color space for consistent color values
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        
        // Extract color components as an array of CGFloat values
        let colorRef = cgColorInRGB.components
        
        // Safely access red, green, and blue components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        // Format RGB values to a hex string
        var color = String(format: "#%02lX%02lX%02lX",
                           lroundf(Float(r * 255)),
                           lroundf(Float(g * 255)),
                           lroundf(Float(b * 255)))

        // Append alpha if the color is translucent
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }
    
    
    /// Initializes a `UIColor` from a hex color code string.
    ///
    /// This initializer is used when you have a hex string that represents a color without
    /// any additional formatting. The string should contain only the hex color code, e.g., `"EFCAFF"`.
    ///
    /// - Parameter hexString: The hex color code as a string, e.g., `"EFCAFF"`.
    /// - Returns: A `UIColor` instance if the hex code is valid; otherwise, `nil`.
    convenience init?(hexString: String) {
        // Remove whitespaces and `#` from the string
        let hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        // Check for valid length: 6 for RGB, 8 for RGBA
        guard hex.count == 6 || hex.count == 8 else { return nil }

        // Scan hex string into an integer
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        // Extract color components
        if hex.count == 6 {
            // RGB format
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            // RGBA format
            let red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    /// Creates a `UIColor` from a hex color code found within a given string.
    ///
    /// This method is useful when you have a string that may contain a hex color code,
    /// and you want to extract it and convert it to a `UIColor`.
    ///
    /// - Parameter hexString: A string containing the hex color code, e.g., `"bg-[#EFCAFF]"`.
    /// - Returns: A `UIColor` if a valid hex code is found and converted successfully; otherwise, `nil`.
    static func color(from hexString: String) -> UIColor? {
        // Define a regular expression pattern to capture the hex color code
        let hexPattern = "#([A-Fa-f0-9]{6})"
        
        // Find the hex code in the input string using the regular expression
        if let hexRange = hexString.range(of: hexPattern, options: .regularExpression) {
            // Extract and trim the '#' character from the hex code
            let hexCode = String(hexString[hexRange]).trimmingCharacters(in: CharacterSet(charactersIn: "#"))
            
            // Convert the hex code to UIColor using the hex initializer
            return UIColor(hexString: hexCode)
        }
        
        print("No valid hex color found in:", hexString)
        return nil
    }
    
}



//MARK: -  UIColor Pattern Image and Tint Color
// https://stackoverflow.com/a/56523612
extension UIColor {
    convenience init(patternImage: UIImage, tintColor: UIColor) {
        var image = patternImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(patternImage.size,
                                               false,
                                               patternImage.scale)
        tintColor.set()
        image.draw(in: CGRect(x: 0, y: 0,
                              width: patternImage.size.width,
                              height: patternImage.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(patternImage: image)
    }
}

//MARK: - other Color extensions
extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

}
