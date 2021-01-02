import Foundation

public enum ApiError: Error {
    case notFound
    case unauthorized
    case badRequest
    case tooManyRequests
    case otherErrors
    case connectionFailure
    case serverError
    case timeout
    case bodyNotFound
    case malformedRequest(_: String?)
    case decodeError(_: Error)
    case unknown(_: Error?)
    
    var requestError: RequestError? {
        switch self {
        case .badRequest,
             .notFound,
             .unauthorized,
             .otherErrors,
             .tooManyRequests:
            return RequestError()
        case .timeout, .connectionFailure:
            return RequestError(title: "Ocorreu um erro", message: "Tente novamente mais tarde")
        default:
            return nil
        }
    }
}
