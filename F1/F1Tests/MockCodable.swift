import Foundation
@testable import F1

class MockCodable<T: Decodable> {
    lazy var decoder: JSONDecoder = JSONDecoder()
    
    @discardableResult
    func loadCodableObject(resource: String,
                           typeDecoder: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        decoder.keyDecodingStrategy = typeDecoder
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: resource, ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let object = try decoder.decode(T.self, from: data)
        return object
    }
}
