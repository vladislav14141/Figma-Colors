//
//  NetworkDataFetcher.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Миронов Владислав on 13.06.2019.
//  Copyright © 2019 Миронов Владислав. All rights reserved.
//



import Foundation

protocol DataFetcher {
    func fetchGenericJsonData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
    func fetchGenericJsonDataCustomModel(urlString: String, response: @escaping ([String: Any]?) -> Void)
    
}

class NetworkDataFetcher {
    
    
    let networking: NetworkService
    
    init(service: NetworkService = NetworkService()) {
        self.networking = service
    }
    
    @discardableResult
    func fetchGenericJsonData<Y: Codable>(urlString: String?, decodeBy: Y.Type, completion: @escaping(Result<Y, APIError>) -> Void) ->  URLSessionDataTask? {
        guard let urlString = urlString else {completion(.failure(.badURL)); return nil}
//        guard let urlRequest = self.networking.makeUrlRequestNonCodable(.get, .applicationJson, body: nil, urlString: urlString, multipartBoundary: "") else { return nil }
//        switch urlRequest {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        guard let urlRequest = self.networking.makeUrlRequest(.get, .applicationJson, body: nil,  urlString: urlString, multipartBoundary: "", completion: completion) else {return nil}
        let time = CFAbsoluteTimeGetCurrent()
        print("URL🧠_________💄 ",urlString)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, err) in
            guard let self = self else { return }
            // MARK:- RACE Condition
            guard response != nil else { return }
            print("time1 - \(CFAbsoluteTimeGetCurrent() - time ), url - \(urlString)")
            
            if let error = self.networking.checkStatusCode(response: response) {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            self.networking.decodeJsonData(data) { (result) in
                completion(result)
            }
            
            print("time2 - \(CFAbsoluteTimeGetCurrent() - time)")
        }
        dataTask.resume()
        
        return dataTask
    }
    
    func fetchDataAndDecodeManually(urlString: String, completion: @escaping(Result<[String: Any], APIError>) -> Void) ->  URLSessionDataTask? {
        guard let resourceURL = URL(string: urlString) else {completion(.failure(.badURL)); return nil}
        print("URL🧠_________💄 ",resourceURL)

        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 45
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        [
            "accept": "application/json"//,
//            "Authorization": "Bearer \(token ?? "")"
            ].forEach({ key, value in
                urlRequest.addValue("\(value)", forHTTPHeaderField: "\(key)")
            })
        let time = CFAbsoluteTimeGetCurrent()
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, err) in
            guard let self = self else { return }
            guard response != nil else { return }

            print("time2 - \(CFAbsoluteTimeGetCurrent() - time ), url - \(urlString)")
            do {
                if let error = self.networking.checkStatusCode(response: response) {
                    completion(.failure(error))
                } else {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    completion(.success(jsonObject ?? [:]))
                }
            }  catch let err as DecodingError{
//                Log("\(err) : Data ----_---- \(err.localizedDescription)")
                completion(.failure(.decodingError(err: err, model: "manually")))
            } catch let err {
                completion(.failure(.customError(err.localizedDescription)))
            }
        }
        dataTask.resume()
        return dataTask
    }
}

