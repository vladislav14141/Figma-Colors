//
//  PostRequest.swift
//  ITMobile
//
//  Created by Миронов Влад on 16.12.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//


/*
protocol DataPoster  {
    func postData<T:Codable,Y:Codable> (requestModel: T, responceModel: Y.Type, urlPath: String, completion: @escaping(Result<Y, APIError>) -> Void)
}

struct NetworkDataPoster: DataPoster {
    let networkDataFetcher = NetworkService()
    
    
    func postData<T:Codable,Y:Codable> (requestModel: T, responceModel: Y.Type, urlPath: String, completion: @escaping(Result<Y, APIError>) -> Void)  {
        let urlString =  "https://rsttur.ru/api\(urlPath)"
        let time = CFAbsoluteTimeGetCurrent()
        print("time1 - \(time), POST URL - \(urlPath)")
        
        
        do {
            let body = try JSONEncoder().encode(requestModel)
            guard let urlRequest = networkDataFetcher.makeUrlRequest(.post, .applicationJson, body: body, urlString: urlString, completion: completion) else {return}

            print("time2 - \(time - CFAbsoluteTimeGetCurrent())")
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {  (data, response, err) in
                
                if let error = self.networkDataFetcher.checkStatusCode(response: response) {
                    completion(.failure(error))
                }
                
                self.networkDataFetcher.decodeJsonData(data, completion: completion)
            }
            
            dataTask.resume()
            
        }  catch let err as DecodingError{
            Log("\(err) : Data ----_---- \(err.localizedDescription)")
            let model = String(describing: Y.self)
            completion(.failure(.decodingError(err: err, model: model)))
        } catch let err {
            completion(.failure(.customError(err.localizedDescription)))
        }
    }
    
    func postDataWithCustomParameters<Y:Codable>(parameters: [String: Any], responceModel: Y.Type, urlString: String?, completion: @escaping(Result<Y, APIError>) -> Void) {
        do {
            guard let urlString = urlString else {completion(.failure(.badURL)); return}
            let jsonParameters = networkDataFetcher.converToJsonDictionary(formData: parameters)
            let body = try JSONSerialization.data(withJSONObject: jsonParameters, options: .prettyPrinted)
            print(jsonParameters)
            guard let urlRequest = networkDataFetcher.makeUrlRequest(.post, .applicationJson, body: body, urlString: urlString, completion: completion) else {return}
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let error = self.networkDataFetcher.checkStatusCode(response: response) {
                    completion(.failure(error))
                }
                
                self.networkDataFetcher.decodeJsonData(data, completion: completion)
            }
            dataTask.resume()
            
        }  catch let err as DecodingError{
            Log("\(err) : Data ----_---- \(err.localizedDescription)")
            let model = String(describing: Y.self)
            completion(.failure(.decodingError(err: err, model: model)))
        } catch let err {
            completion(.failure(.customError(err.localizedDescription)))
        }
    }
    
    func postDataWithCustomParametersDictionary(parameters: [String: Any], urlString: String?, completion: @escaping(Result<[String: Any], APIError>) -> Void) {
        do {
            guard let urlString = urlString else {completion(.failure(.badURL)); return}
            let jsonParameters = networkDataFetcher.converToJsonDictionary(formData: parameters)
            let body = try JSONSerialization.data(withJSONObject: jsonParameters, options: .prettyPrinted)
            print(jsonParameters)
            guard let urlRequest = networkDataFetcher.makeUrlRequestNonCodable(.post, .applicationJson, body: body, urlString: urlString, completion: { (err) in
                completion(.failure(err))
            }) else { return }
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let error = self.networkDataFetcher.checkStatusCode(response: response) {
                    completion(.failure(error))
                }
                
                self.networkDataFetcher.decodeJsonDataDictionary(data, completion: completion)
            }
            dataTask.resume()
            
        }  catch let err as DecodingError{
            Log("\(err) : Data ----_---- \(err.localizedDescription)")
            completion(.failure(.decodingError(err: err, model: "")))
        } catch let err {
            completion(.failure(.customError(err.localizedDescription)))
        }
    }
    
    func postFile<Y:Codable> (parameters: [String: Any], attachment: [FileModel]?,responceModel: Y.Type, urlPath: String?, completion: @escaping(Result<Y, APIError>) -> Void)  {
        
        guard let urlString =  urlPath?.fillURL() else {completion(.failure(.badURL));return}
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let dataBody = createDataBody(withParameters: parameters, media: attachment, boundary: boundary)
        guard let urlRequest = networkDataFetcher.makeUrlRequest(.post, .multipart, body: dataBody, urlString: urlString, multipartBoundary: boundary, completion: completion) else {return}

        let dataTask = URLSession.shared.uploadTask(with: urlRequest, from: nil) { (data, response, err) in
            
            if let error = self.networkDataFetcher.checkStatusCode(response: response) {
                completion(.failure(error))
            }
            
            self.networkDataFetcher.decodeJsonData(data, completion: completion)
        }
        
        dataTask.resume()
    }
    
    fileprivate func createDataBody(withParameters params: [String: Any]?, media: [FileModel]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        var key: String!
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
                body.append("\(value)\(lineBreak)".data(using: .utf8)!)
            }
        }
        
        if let media = media {
            for (_, file) in media.enumerated() {
                key = file.sendKey
                guard let key = file.sendKey else {
                    fatalError("SendKey can't be nil, Example: UploadForm[imageFiles][]")
                }
                body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(file.filename)\"\(lineBreak)".data(using: .utf8)!)
                body.append("Content-Type: .\(file.fileExtension + lineBreak + lineBreak)".data(using: .utf8)!)
                body.append(file.data!)
                print(file.fileExtension)
                body.append(lineBreak.data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key ?? "")\"\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }
    
}
*/
