import Foundation

class Api<E: Decodable> {
    typealias Completion = ApiCompletion.Completion<E>
    typealias Success = ApiCompletion.Success<E>
    typealias Result = ApiCompletion.ApiResult<E>
    
    private let endpoint: ApiEndpoint
    
    init(endpoint: ApiEndpoint) {
        self.endpoint = endpoint
    }
    
    func request(session: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil),
                 jsonDecoder: JSONDecoder = JSONDecoder(),
                 _ completion: @escaping Completion) {
        let request: URLRequest
        do {
            try request = makeRequest()
        } catch {
            completion(Result.failure(.malformedRequest("Unable to make request")))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error  in
            self.handle(request: request,
                        responseBody: data,
                        response: response,
                        error: error,
                        jsonDecoder: jsonDecoder,
                        completion: completion)
        }
        task.resume()
    }
    
    private func makeRequest() throws -> URLRequest {
        var urlComponent = URLComponents(string: endpoint.absoluteStringUrl)
        if endpoint.method == .get && !endpoint.parameters.isEmpty {
            urlComponent?.queryItems = self.endpoint.parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponent?.url else {
            throw ApiError.malformedRequest("Unable to parse url")
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = endpoint.method.rawValue

        let allHeaders = defaultRequestHeaders().merging(endpoint.customHeaders) { current, _ in current }
        allHeaders.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    private func defaultRequestHeaders() -> [String: String] {
        [:]
    }
    
    private func handle(request: URLRequest,
                        responseBody: Data?,
                        response: URLResponse?,
                        error: Error?,
                        jsonDecoder: JSONDecoder,
                        completion: Completion) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(Result.failure(.connectionFailure))
            return
        }
        
        let status = HTTPStatusCode(rawValue: httpResponse.statusCode) ?? .processing
        let result: Result
        
        switch status {
        case .ok, .created, .accepted, .noContent:
            result = handleSuccess(responseBody: responseBody, jsonDecoder: jsonDecoder)
        case .badRequest, .unprocessableEntity, .preconditionFailed, .preconditionRequired:
            result = .failure(.badRequest)
        case .unauthorized:
            result = .failure(.unauthorized)
        case .notFound:
            result = .failure(.notFound)
        case .tooManyRequests:
            result = .failure(.tooManyRequests)
        case .requestTimeout:
            result = .failure(.timeout)
        case .internalServerError, .badGateway, .serviceUnavailable:
            result = .failure(.serverError)
        default:
            result = .failure(.otherErrors)
        }
        
        completion(result)
    }
}

extension Api {
    private func handleSuccess(responseBody: Data?, jsonDecoder: JSONDecoder) -> Result {
        switch E.self {
        case is Data.Type:
            return contentData(responseBody)
        default:
            return decodeContentData(responseBody, jsonDecoder: jsonDecoder)
        }
    }
    
    private func contentData(_ responseBody: Data?) -> Result {
        guard let response = responseBody as? E else {
            return .failure(.bodyNotFound)
        }

        let success = Success(model: response, data: responseBody)
        return .success(success)
    }

    private func decodeContentData(_ responseBody: Data?, jsonDecoder: JSONDecoder) -> Result {
        do {
            let decoded = try jsonDecoder.decode(E.self, from: responseBody ?? Data())
            let result = Success(model: decoded, data: responseBody)
            return .success(result)
        } catch {
            return .failure(.decodeError(error))
        }
    }
}
