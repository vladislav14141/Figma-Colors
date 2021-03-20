//
//  NetworkService.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Миронов Владислав on 31/05/2019.
//  Copyright © 2019 Миронов Владислав. All rights reserved.
//

import Foundation

//protocol Networking {
//    func makeUrlRequest<Y:Codable>(_ requestType: RequestType, _ contentType: ContentType, body: Data?, urlString: String, multipartBoundary: String, completion: @escaping(Result<Y, APIError>) -> Void) -> URLRequest?
//    func makeUrlRequestNonCodable(_ requestType: RequestType, _ contentType: ContentType, body: Data?, urlString: String, multipartBoundary: String, completion: @escaping(APIError) -> Void) -> URLRequest?
//    func decodeJsonData<Y:Codable>(_ jsonData: Data?, completion: @escaping(Result<Y, APIError>) -> Void)
//    func checkServerError(jsonData: Data?) -> APIError?
//    func checkStatusCode(response: URLResponse?) -> APIError?
//}

enum ContentType {
    case multipart
    case applicationJson
    case formData
}


enum RequestType {
    case get
    case post
}

enum APIError: Error, LocalizedError, Equatable {
    
    case badURL
    case statusCodeError(Int)
    case decodingError(err: Error, model: String)
case responseError
    case customError(String)
    case isNoAccess
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.title == rhs.title
    }
    
    var title: String {
        switch self {
            case .isNoAccess:
                return "Вам запрещен доступ!"
            case .decodingError(let error, let model):
                if let err = error as? DecodingError {
                    switch err {
                        
                        case .typeMismatch(let key, let value):
                            return "error \(key), value \(value) and ERROR: \(error.localizedDescription)"
                        case .valueNotFound(let key, let value):
                            return "error \(key), value \(value) and ERROR: \(error.localizedDescription)"
                        case .keyNotFound(let key, let value):
                            return "error \(key), value \(value) and ERROR: \(error.localizedDescription)"
                        case .dataCorrupted(let key):
                            return "error \(key), value corrupted and ERROR: \(error.localizedDescription)"

                        @unknown default:
                            return ""
                    }
                } else {
                    return error.localizedDescription
                }
            case .statusCodeError(let status):
                return "Bad response code: \(status)"
            case .customError(let err):
                return err
            case .badURL:
                return URLError(URLError.badURL).localizedDescription
        case .responseError: return "Данные не получены"
        }
    }
}

class NetworkService {
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func makeUrlRequestNonCodable(_ requestType: RequestType, _ contentType: ContentType, body: Data?, urlString: String, multipartBoundary: String = "") -> Result<URLRequest, APIError>? {
        guard let resourceURL = URL(string: urlString) else { return .failure(.badURL) }
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.timeoutInterval = 45

        switch contentType {
            case .formData:
                urlRequest.addValue("form-data", forHTTPHeaderField: "Content-Type")
            
            case .applicationJson:
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue("\(body?.count ?? 0)", forHTTPHeaderField: "Content-Length")
            case .multipart:
                let boundary = multipartBoundary
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        switch requestType {
            case .get:
                urlRequest.httpMethod = "GET"
            case .post:
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = body
        }
        return .success(urlRequest)
    }
    
    func makeUrlRequest<Y:Codable>(_ requestType: RequestType, _ contentType: ContentType = .applicationJson, body: Data? = nil, urlString: String, multipartBoundary: String = "", completion: @escaping(Result<Y, APIError>) -> Void) -> URLRequest? {
        guard let resourceURL = URL(string: urlString) else {completion(.failure(.badURL)); return nil}

        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.timeoutInterval = 45

        
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
//            let versionBuild = "\(version).\(build)"
//            urlRequest.addValue("\(versionBuild)", forHTTPHeaderField: "App-Version")
//            print("Version", versionBuild)
//       }
        
        
        urlRequest.addValue("165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", forHTTPHeaderField: "X-Figma-Token")
        switch contentType {
            case .formData:
                urlRequest.addValue("form-data", forHTTPHeaderField: "Content-Type")

            case .applicationJson:
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                urlRequest.addValue("\(body?.count ?? 0)", forHTTPHeaderField: "Content-Length")
            case .multipart:
                let boundary = multipartBoundary
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }

        switch requestType {
            case .get:
                urlRequest.httpMethod = "GET"
            case .post:
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = body
        }
        return urlRequest
    }
    
    func decodeJsonData<Y:Codable>(_ jsonData: Data?, completion: @escaping(Result<Y, APIError>) -> Void) {
        guard let jsonData = jsonData else {completion(.failure(.responseError)); return}
        
        do {
            
            let decodedData = try jsonDecoder.decode(Y.self, from: jsonData)
            
            #if DEBUG
            let str = String(describing: decodedData)
            print(">>🐰🐶<< DecodedData  :  ", str.count > 500 ? str.prefix(500) : str)
            #endif
            
            completion(.success(decodedData))
        } catch let err {
            #if DEBUG
            if let str = String(bytes: jsonData, encoding: .utf8) {
                print(">>🐰🐶<< DecodedData  :  ", str.count > 500 ? str.prefix(500) : str)
            }
            #endif
            completion(.failure(.decodingError(err: err, model: String(describing: Y.self))))
            
        }
    }
    
    func decodeJsonDataDictionary(_ jsonData: Data?, completion: @escaping(Result<[String: Any], APIError>) -> Void) {
        guard let jsonData = jsonData else {completion(.failure(.customError("Данные не получены"))); return}
        
        do {
            let decodedData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            #if DEBUG
            let str = String(describing: decodedData)
            print(">>🐰🐶<< DecodedData  :  ", str.count > 500 ? str.prefix(500) : str)
            #endif
            if let decodedData = decodedData {
                completion(.success(decodedData))
            } else {
                completion(.failure(.customError("Ответ от сервера не может быть прочитан")))
            }
        } catch let err {
            #if DEBUG
            if let str = String(bytes: jsonData, encoding: .utf8) {
                print(">>🐰🐶<< DecodedData  :  ", str.count > 500 ? str.prefix(500) : str)
            }
            #endif
            completion(.failure(.decodingError(err: err, model: "")))
            
        }
    }
    
    // MARK:- Convert UploadForm[imageFiles][] to [..:..]
    
    /// Рекурсивная функция, конвертирует словарь формдаты в словарь json
    /// - Parameter formData: [UploadForm[imageFiles][] : ["Photo1", "Photo2", "Photo3"]]
    /// - Returns: ["UploadForm": ["imageFiles": ["Photo1", "Photo2", "Photo3"]]]
    func converToJsonDictionary(formData: [String: Any]) -> [String: Any]{
        var initialDictionary = [String: Any]()
        
        formData.forEach({ key, value in
            var jsonKey = key
            var formDataKey = key
            
            for (i, char) in key.enumerated() {
                if i == 0 && char == "[" {
                    continue
                } else if char == "[" {
                    jsonKey = String(key.dropFirst(i))
                    formDataKey = String(key.dropLast(key.count - i))
                    break
                } else if char == "]" {
                    jsonKey = String(key.dropFirst(i + 1))
                    formDataKey = String(key.dropLast(key.count - i).dropFirst())
                    break
                }
            }
            
            let nextDict = [jsonKey: value]
            
            if jsonKey.contains("[") {
                let jsonDictionary = converToJsonDictionary(formData: nextDict)
                if var currentDict = initialDictionary[formDataKey] as? [String: Any] {
                    
                    jsonDictionary.forEach({
                        currentDict[$0.key] = $0.value
                    })
                    initialDictionary[formDataKey] = currentDict
                    
                } else {
                    if let array = jsonDictionary[""] {
                        initialDictionary[formDataKey] = array
                        
                    } else {
                        
                        initialDictionary[formDataKey] = jsonDictionary
                    }
                }
                
            } else {
                initialDictionary[formDataKey] = value
            }
            
        })
        return initialDictionary
    }
    
    func checkStatusCode(response: URLResponse?) -> APIError? {
        guard let httpResponse = response as? HTTPURLResponse else { return .responseError}
        switch httpResponse.statusCode {
            case 200..<300: print("Status code 200..<300"); return nil
            case 403: return .isNoAccess
            default: return .statusCodeError(httpResponse.statusCode)
        }
    }

//    func checkServerError(jsonData: Data?) -> APIError? {
//        guard let data = jsonData else {return .customError("Что-то пошло не так!")}
//        guard let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return .customError("Что-то пошло не так!")}
//        if let errorInData = dataDictionary["error"], (errorInData is [String] || errorInData is [String: Any]) {
//            let message = findErrorMessage(errorInData)
//            if let code = message.code, code == "403" {
//                return .isNoAccess
//            }
//            return .customError(message.message as? String ?? "Что-то пошло не так!")
//        } else if let message = dataDictionary["message"] {
//            return .customError(message as? String ?? "Что-то пошло не так!")
//        }
//        return nil
//    }
//    func checkServerError(jsonData: Data?) -> APIError? {
//        guard let data = jsonData else {return .customError("Что-то пошло не так!")}
//        guard let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return .customError("Что-то пошло не так!")}
//        if let errorInData = dataDictionary["error"], (errorInData is [String] || errorInData is [String: Any]) {
//            let message = findErrorMessage(errorInData)
//            if let code = message.code, code == "403" {
//                return .isNoAccess
//            }
//            return .customError(message.message as? String ?? "Что-то пошло не так!")
//        } else if let message = dataDictionary["message"] {
//            return .customError(message as? String ?? "Что-то пошло не так!")
//        }
//        return nil
//    }

//    func findErrorMessage(_ data: Any, statusCode: String? = nil) -> (message: Any?, code: String?){
//        var code: String? = statusCode
//
//        if let data = (data as? [Any])?.first {
//            return findErrorMessage(data, statusCode: code)
//
//        } else if let data = (data as? [String: Any]) {
//            if let codeDic = data["status"] as? String {
//                code = codeDic
//            }
//
//            if let message = data["message"] ?? data["text"] ?? data["title"] ?? data["messages"] {
//                return findErrorMessage(message, statusCode: code)
//
//            } else if let data = Array(data.values) as? [String] {
//                let reduced = data.reduce("", { $0 + "\($1)" + "\n" })
//                return findErrorMessage(reduced, statusCode: code)
//
//            } else if let data = data.values.first {
//                return findErrorMessage(data, statusCode: code)
//            }
//
//        } else if let data = data as? String {
//            return (data, code)
//        }
//        return (data, code)
//    }
//
//    func checkServerError1(jsonData: Data?) -> String? {
//        guard let data = jsonData else {return "Данные отсутствуют"}
//        guard let errorInData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return "Произошла ошибка"}
//        if let serverMessage = (errorInData["message"] as? String) {
//            return serverMessage
//        } else if let serverMessage = (errorInData["error"] as? [String: Any]) {
//            if let message = (serverMessage["message"] ?? serverMessage["text"] ?? serverMessage["title"]) as? String   {
//                return message
//            } else if let message = serverMessage.values.first as? String{
//                return message
//            } else {
//                let allItems = serverMessage.values.reduce("", { (result, item) -> String in
//                    result + "\(item as? String ?? "")\n"
//                })
//                return allItems
//            }
//
//        } else if let serverMessage = errorInData["error"] as? [[String: Any]], let first = serverMessage.first  {
//
//            if let message = (first["message"] ?? first["text"] ?? first["title"]) as? String {
//                return message
//            } else if let message = first.values.first as? String {
//                return message
//            } else {
//                let allItems = serverMessage.first?.values.reduce("", { (result, item) -> String in
//                    result + "\(item as? String ?? "")\n"
//                })
//                return allItems
//            }
//
//        } else if let success = errorInData["success"] as? Bool, success == false {
//            return String(describing: errorInData)
//        }
//        return nil
//    }
}
