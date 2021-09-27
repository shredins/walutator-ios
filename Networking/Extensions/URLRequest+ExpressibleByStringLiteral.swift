import Foundation

extension URLRequest: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        guard let url = URL(string: value) else {
            fatalError("Incorrect value used to create URL")
        }
        
        self.init(url: url)
    }
}
