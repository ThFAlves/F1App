import Foundation

class ApiCompletion {
    typealias Success<E: Decodable> = (model: E, data: Data?)
    typealias ApiResult<E: Decodable> = Result<Success<E>, ApiError>
    typealias Completion<E: Decodable> = (ApiResult<E>) -> Void
}
