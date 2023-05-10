//  Extensions.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 18/12/2020.

import SwiftUI
import Alamofire
import WebKit

// MARK: - UIDevice
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

// MARK: - Binding
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}

// MARK: - URLRequest
extension URLRequest {
    init(baseUrl: String, path: String, method: HTTPMethod, params: [String: Any]) {
        let url = URL(baseUrl: baseUrl, path: path, params: params)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

// MARK: - URL
extension URL {
    init(baseUrl: String, path: String, params: [String: Any]) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        components.queryItems = params.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        self = components.url!
    }
}

// MARK: - Bundle
extension Bundle {
    static let sdkBundle = Bundle(identifier: "org.cocoapods.ApolloMobileSDK")
    
    static let dataBundle: Bundle = {
        let dataPath = sdkBundle!.path(forResource: "Data", ofType: "bundle")
        let dataBundle = Bundle(url: URL(fileURLWithPath: dataPath!))
        return dataBundle!
    }()
    
    static let resourceBundle: Bundle = {
        let resourcePath = sdkBundle!.path(forResource: "Resources", ofType: "bundle")
        let resourceBundle = Bundle(url: URL(fileURLWithPath: resourcePath!))
        return resourceBundle!
    }()
    
    static let languagePath: String = {
        let languageCode = getPreferredLocale().languageCode
        let resourcePath = resourceBundle.path(forResource: languageCode, ofType: "lproj") ?? resourceBundle.path(forResource: "en", ofType: "lproj") ?? ""
        return resourcePath
    }()
    
    static func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    static let fontBundle: Bundle = {
        let fontPath = sdkBundle!.path(forResource: "Fonts", ofType: "bundle")
        let fontBundle = Bundle(url: URL(fileURLWithPath: fontPath!))
        return fontBundle!
    }()
}

// MARK: - Colors
extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - String
extension String {
    func parseExpriationYearAndMonth() -> (month: String, year: String) {
        return (month: String(self.suffix(2)), year: "20\(String(self.prefix(2)))")
    }
    
    func getCurrencySymbol() -> String? {
        return "$"
//        let locale = NSLocale(localeIdentifier: self)
//        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: self)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont, textAlignment: NSTextAlignment, lineHeightMultiple: CGFloat = 1.2) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes:
            [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
            ], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont, textAlignment: NSTextAlignment) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.2
        
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSMutableAttributedString {
    var range: NSRange {
        NSRange(location: 0, length: self.length)
    }
}

// MARK: - Double
extension Double {
    func toString(decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}

// MARK: - View
extension View {
    
    @ViewBuilder func isHidden(_ value: Bool) -> some View {
        if value { self.hidden() }
        else { self }
    }
    
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        condition ? AnyView(content(self)) : AnyView(self)
    }
    
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - UIFont
extension UIFont {
    static func loadCustomFont(_ fileName: String) throws {
        guard let fontURL = Bundle.fontBundle.url(forResource: fileName, withExtension: "ttf") else {
            throw AttFontLoadingError.fileNotFound
        }
        
        guard
            let provider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(provider)
        else {
            throw AttFontLoadingError.unreadableFontData
        }
        
        var cfError: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &cfError)
        
        if let error = cfError as? Error {
            throw error
        }
    }
}

// MARK: - Font
extension Font  {
    
    static func custom(_ type: AttSDKFont, size: CGFloat) -> Font {
        .custom(type.rawValue, size: size)
    }
    
}

// MARK: - List
extension List {
    @ViewBuilder func noSeparators() -> some View {
        #if swift(>=5.3) // Xcode 12
        if #available(iOS 14.0, *) { // iOS 14
            self
                .accentColor(Color.secondary)
                .listStyle(SidebarListStyle())
                .onAppear {
                    UITableView.appearance().backgroundColor = UIColor.systemBackground
                }
        } else { // iOS 13
            self
                .listStyle(PlainListStyle())
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
        }
        #else // Xcode 11.5
        self
            .listStyle(PlainListStyle())
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
        #endif
    }
}

extension Color {
    public func uiColor() -> UIColor {

        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

extension WKWebView {
    
    // it re-execute javascript in cases when body is attached additionally on the html by some inner javascript framework
    // it tries around 50 times maximum in time range of 10 sec
    // if body is not loaded in 10 secs, this won't work
    func rexecuteJavascript(tryouts: Int = 0, script: String) {
        self.evaluateJavaScript(script, completionHandler: { (result: Any?, error: Error?) in
            if let _ = error, tryouts < 50 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    return self.rexecuteJavascript(tryouts: tryouts + 1, script: script)
                }
            }
        })
    }
}




extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
}

extension NSRange {
    init(_ range: Range<String.Index>, in string: String) {
        self.init()
        let startIndex = range.lowerBound.samePosition(in: string.utf16)
        let endIndex = range.upperBound.samePosition(in: string.utf16)
        self.location = string.distance(from: string.startIndex,
                                        to: range.lowerBound)
        guard let startInd = startIndex, let endInd = endIndex else {return}
        self.length = string.distance(from: startInd, to: endInd )
    }
}


struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)

    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.view.backgroundColor = .clear
        toPresent.modalTransitionStyle = .crossDissolve
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "dismissModal"), object: nil, queue: nil) { [weak toPresent] _ in
            toPresent?.dismiss(animated: true, completion: nil)
        }
        
        // Case when there is already presented navigation viewController, so we need to present our view over it...
        if let navigationVC = (self as? UINavigationController), let presentedVc = navigationVC.presentedViewController {
            presentedVc.present(toPresent, animated: true, completion: nil)
            return
        }
        
        // default case
        self.present(toPresent, animated: true, completion: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}







struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainer {

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}


extension UINavigationController {
    func pushDashboardViewController(type: AttDashboardType? = nil) {
        let dashboardVC = AttDashboardController(type: .normal)
        if let first = self.viewControllers.first(where: {$0 is AttDashboardController}) as? AttDashboardController {
            if let type = type {
                first.setType(type: type)
            }
            self.popToViewController(first, animated: false)
        } else {
            self.pushViewController(dashboardVC, animated: false)
        }
    }
    
    func setRootDashboardViewController() {
        let dashboardVC = AttDashboardController(type: .normal)
        self.setViewControllers([dashboardVC], animated: true)
    }
}
