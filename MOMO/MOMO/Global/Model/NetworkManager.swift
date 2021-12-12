//
//  NetworkManager.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/12.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case failResponse
    case invalidData
}

protocol Networkable {
    func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Networkable {}

typealias URLSessionResult = ((Result<Data, Error>) -> Void)

class NetworkManager {
    static let baseUrl = ""
    private let boundary = "Boundary-\(UUID().uuidString)"
    private let parsingManager = ParsingManager()
    private let session: Networkable
    
    init(session: Networkable = URLSession.shared) {
        self.session = session
    }
    
    func request(apiModel: APIable, completion: @escaping URLSessionResult) {
        guard let url = URL(string: apiModel.url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiModel.requestType.method
        request.httpBody = createDataBody(parameter: apiModel.param, contentType: apiModel.contentType)
        
        switch apiModel.contentType {
        case .multiPartForm:
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        case .jsonData:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .noBody:
            break
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.failResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            completion(.success(data))
        } .resume()
    }
}

extension NetworkManager {
    
    private func createDataBody(parameter: [String: String?]?, contentType: ContentType) -> Data? {
        var body = Data()
        let lineBreak = "\r\n"
        
        if let modelParameter = parameter {
            if contentType == .multiPartForm {
                for (key, value) in modelParameter {
                    body.append(convertTextField(key: key, value: "\(value ?? "")"))
                }
                body.append("--\(boundary)--\(lineBreak)")
            } else {
                if let data = parsingManager.encodingModel(model: parameter){
                    body = data
                }
            }
        } else {
            return nil
        }
        return body
    }
    
    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        let lineBreak = "\r\n"
        var dataField = Data()
        
        dataField.append("--\(boundary + lineBreak)")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
        dataField.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        dataField.append(value)
        dataField.append(lineBreak)
        
        return dataField
    }
    
    private func convertTextField(key: String, value: String) -> Data {
        let lineBreak = "\r\n"
        var textField = Data()
        
        textField.append("--\(boundary + lineBreak)")
        textField.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        textField.append("\(value)\(lineBreak)")
        
        return textField
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


