//
//  NetworkCachedDataFetcher.swift
//  AppConstructor
//
//  Created by Владислав Миронов on 04.05.2021.
//

import Foundation
import Cache
class NetworkCachedDataFetcher: NetworkDataFetcher {
    let cacheHelper = CacheHelper.shared
    
    @discardableResult
    override func fetchGenericJsonData<Y: Codable>(urlString: String?, decodeBy: Y.Type, completion: @escaping (Swift.Result<Y, APIError>) -> Void) -> URLSessionDataTask? {
        let storage = cacheHelper.storage(decodeBy: decodeBy)

        storage.async.object(forKey: urlString!) { (result) in
            switch result {
            case .value(let value):
                completion(.success(value))
            case .error(let err):
                print(err)
            }
        }

        return super.fetchGenericJsonData(urlString: urlString, decodeBy: decodeBy) { (result) in
            switch result {
            case .success(let responce):
                completion(.success(responce))
                try! storage.setObject(responce, forKey: urlString!)
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    @discardableResult
    override func fetchDataAndDecodeManually(urlString: String?, completion: @escaping (Swift.Result<[String : Any], APIError>) -> Void) -> URLSessionDataTask? {

        return super.fetchDataAndDecodeManually(urlString: urlString ?? "") { (result) in
            switch result {
            case .success(let responce):
                completion(.success(responce))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
