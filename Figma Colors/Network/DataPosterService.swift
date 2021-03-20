//
//  DataPosterService.swift
//  ITMobile
//
//  Created by Миронов Влад on 16.12.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//
//import UIKit

/*
class DataPosterService {
    
    enum EditModeAction: String {
        case reserve = "/mobile/reserve"
        case sale = "/mobile/sale"
        case clearReserve = "/mobile/clear-reserve"
        case clear = "/mobile/clear"
        case price = "/mobile/price"
    }
    var networkDataPoster: NetworkDataPoster
    init() {
        self.networkDataPoster = NetworkDataPoster()
    }
    
    // декодируем полученные JSON данные в конкретную модель данных
    
    let EXAMPLE___URL = "https://rsttur.ru/api/token"
    
    // MARK:- Auth
    func refreshToken(requestModel: RefreshTokenModel, completion: @escaping(Result<DecodableAuthModel, APIError>) -> Void) {
        let urlPath = "/oauth/token"
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableAuthModel.self, urlPath: urlPath) {
            completion($0)
        }
    }
    func auth(requestModel: AuthModel, completion: @escaping(Result<DecodableAuthModel, APIError>) -> Void) {
        let urlPath = "/oauth/token"
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableAuthModel.self, urlPath: urlPath) { (result) in
            
            completion(result)
        }
    }
    
    func refreshToken(requestModel: AuthModel, completion: @escaping(Result<DecodableAuthModel, APIError>) -> Void) {
        let urlPath = "/oauth/token"
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableAuthModel.self, urlPath: urlPath) { (result) in
            
            completion(result)
        }
    }
    
    func registration(requestModel: RegModel, completion: @escaping(Result<DecodableRegModel, APIError>) -> Void) {
        let urlPath = "/oauth/registration"
        
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableRegModel.self, urlPath: urlPath) { (result) in
            completion(result)
        }
    }
    
    func forgotPassword(requestModel: ForgotPasswordModel, completion: @escaping(Result<DecodableForgotModel, APIError>) -> Void) {
        let urlPath = "/oauth/forgot-password"
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableForgotModel.self, urlPath: urlPath) { (result) in
            completion(result)
        }
    }
    
    // MARK:- Calendar
    func editModeRequests(requestModel: BaseCalendarModel,urlPath: EditModeAction, completion: @escaping(Result<DecodableHeaderSample, APIError>) -> Void) {
        
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableHeaderSample.self, urlPath: urlPath.rawValue) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    func smsRequest(requestModel: PostSmsModel, completion: @escaping(Result<DecodableHeaderSample, APIError>) -> Void) {
        let urlPath = "/mobile/sms"
        
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableHeaderSample.self, urlPath: urlPath) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    // MARK:- Order
    func orderTokenRequest(requestModel: PostOrderTokenModel, id: String, completion: @escaping(Result<PostDecoderOrderTokenModel, APIError>) -> Void) {
        let urlPath = "/mobile-order/token?id=\(id)"
        
        networkDataPoster.postData(requestModel: requestModel, responceModel: PostDecoderOrderTokenModel.self, urlPath: urlPath) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    
    func createPayRequest(requestModel: PostCreatePayModel,id: String, isTourst: Bool, completion: @escaping(Result<DecodableHeaderSample, APIError>) -> Void) {
        let token = realm.objects(TokensRealmModel.self).first?.accessToken ?? ""
        let urlPath = "/mobile-order/create-pay-\(isTourst ? "tourist": "operator")?id=\(id)&token=\(token)"
        
        networkDataPoster.postData(requestModel: requestModel, responceModel: DecodableHeaderSample.self, urlPath: urlPath) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    
    func sendFormRequest(parameters: [String: Any], url: String?, completion: @escaping(Result<DecodableHeaderSample, APIError>) -> Void) {
        networkDataPoster.postDataWithCustomParameters(parameters: parameters, responceModel: DecodableHeaderSample.self, urlString: url) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    
    func createCommentRequest(parameters: [String: String], attachment: [FileModel]?, id: String, completion: @escaping(Result<DecoderOrderCommentsModel, APIError>) -> Void) {
        let token = realm.objects(TokensRealmModel.self).first?.accessToken ?? ""
        let urlPath = "/api/mobile-order/send-comment?id=\(id)&token=\(token)"
        networkDataPoster.postFile(parameters: parameters, attachment: attachment, responceModel: DecoderOrderCommentsModel.self, urlPath: urlPath) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    

    func updateHouse(orderId: Int, currentHomeId: Int, updatePrice: Bool, completion: @escaping(Result<PostUpdateHomeDecoder, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile-order/update-home?id=\(orderId)"
        networkDataPoster.postDataWithCustomParameters(parameters: ["home_id": currentHomeId, "updatePrice": updatePrice], responceModel: PostUpdateHomeDecoder.self, urlString: url, completion: completion)
    }
    
    func updateBus(orderId: Int, busThere: [String], busBack: [String], completion: @escaping(Result<DecodableHeaderSample, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile-order/update-place-bus?id=\(orderId)"
        networkDataPoster.postDataWithCustomParameters(parameters: ["busThere": busThere, "busBack": busBack], responceModel: DecodableHeaderSample.self, urlString: url, completion: completion)
    }
    
    func sendFileRequest(url: String?, parameters: [String: Any], attachment: [FileModel]?, completion: @escaping(Result<PostFilesModelDecoder, APIError>) -> Void) {
        networkDataPoster.postFile(parameters: parameters, attachment: attachment, responceModel: PostFilesModelDecoder.self, urlPath: url) { (result) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    // MARK:- Chat
    func uploadChatFiles(parameters: [String: String], files: [FileModel],completion:  @escaping(Result<PostChatFileModel, APIError>) -> Void ) {
        networkDataPoster.postFile(parameters: parameters,
                                   attachment: files,
                                   responceModel: PostChatFileModel.self,
                                   urlPath: "/api/gallery/upload?onlyUpload=true",
                                   completion: completion)
    }
    
    //MARK: - Profile
    func readNotice(ids: [Int], completion: @escaping (Result<[String : Any], APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/notice-read"
        networkDataPoster.postDataWithCustomParametersDictionary(parameters: ["id": ids], urlString: url, completion: completion)
    }

    func deleteNotice(ids: [Int], completion: @escaping (Result<[String : Any], APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/notice-delete"
        networkDataPoster.postDataWithCustomParametersDictionary(parameters: ["id": ids], urlString: url, completion: completion)
    }    
}
*/
