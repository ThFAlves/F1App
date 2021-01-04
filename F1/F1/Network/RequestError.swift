import Foundation

struct RequestError: Error {
    public var title: String
    public var message: String

    public init() {
        message = "Ocorreu um erro ao carregar as informações, tente novamente."
        title = "Problema na conexão"
    }
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
