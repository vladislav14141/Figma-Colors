//
//  DataFetcherService.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Миронов Влад on 10.09.2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

/*
class DataFetcherService {
    
    var networkDataFetcher = NetworkDataFetcher()

    // декодируем полученные JSON данные в конкретную модель данных
    let mainUrl = "https://rsttur.ru/api/"
    var mainUrlComponents: URLComponents{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rsttur.ru"
        urlComponents.path = "/api"
        return urlComponents
    }
    
    // MARK:- Custom Request
    func fetchWithCustom<Y: Codable>(url: String, decodeModel: Y.Type, completion: @escaping(Result<Y, APIError>) -> Void) {
        networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
            completion(result)
        }
    }
    
    
    // MARK:- Calendar
    func fetchGetBases(completion: @escaping(Result<GetBasesModel, APIError>) -> Void) {
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile/get-bases"
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
                completion(result)
            }
        }
    }
    
    
    
    func fetchGetAreas(baseId: Int, completion: @escaping(Result<GetAreasModel, APIError>) -> Void) {
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile/get-areas"
        urlComponents.queryItems = [ URLQueryItem( name: "id", value: "\(baseId)" ) ]
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
                completion(result)
            }
        }
    }
    
    func fetchGetInit(completion: @escaping(Result<GetInitModel, APIError>) -> Void) {
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile/init"
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url,completion: completion) 
            }
    }


    func fetchCalendarData(baseId: Int, areaId: [Int], date: String, completion: @escaping(Result<RequestInfo, APIError>) -> Void) ->  URLSessionDataTask? {
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile/table"
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: "\(baseId)"),
            URLQueryItem(name: "date", value: "\(date)"),
            URLQueryItem(name: "short", value: "1")
        ]

        areaId.forEach({ urlComponents.queryItems?.append( URLQueryItem( name: "area_id[]", value: "\($0)") ) } )
        guard let url = urlComponents.url?.absoluteString else {completion(.failure(.badURL)); return nil}
            return self.networkDataFetcher.fetchDataAndDecodeManually(urlString: url) { (result) in
                switch result {
                    
                case .success(let response):
                    let decoded = RequestInfo(data: response)
                    completion(.success(decoded))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
    
    // MARK:- Order
    func fetchOrderList(page: Int?, idOrFamily: String?, dateRange: String?, tab: [GetTabsModel.Param]? , completion: @escaping(Result<GetOrderListModel, APIError>) -> Void) ->  URLSessionDataTask?{
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile-order/list"
        urlComponents.queryItems = []

        if let page = page { urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let idOrFamily = idOrFamily {urlComponents.queryItems?.append(URLQueryItem(name: "OrderSerch[quickSearch]", value: idOrFamily))}
        if let dateRange = dateRange { urlComponents.queryItems?.append(URLQueryItem(name: "OrderSerch[date]", value: "\(dateRange)"))}
        if let tab = tab {
            tab.forEach({
                if let name = $0.name, let value = $0.value {
                    urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
                }
            })
        }


        if let url = urlComponents.url?.absoluteString {
            return networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
                completion(result)
            }
        } else {
            return nil
        }
    }
    
    enum TabType: String {
        case order = "/mobile-order/tabs"
        case arriveIn = "/mobile/check-in-tabs"
        case arriveOut = "/mobile/check-out-tabs"
        case finance = "/mobile/finance-tabs"
    }
    
    func fetchTabs(tabType: TabType, date: String?, id: Int? = nil, baseID: Int?, areaID: [Int], completion:  @escaping(Result<GetTabsModel, APIError>) -> Void) {
        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + tabType.rawValue
        urlComponents.queryItems = []
        if let date = date { urlComponents.queryItems?.append(URLQueryItem(name: "date", value: date)) }
        if let baseID = baseID {urlComponents.queryItems?.append(URLQueryItem(name: "base_id", value: "\(baseID)"))}
        if let id = id {urlComponents.queryItems?.append(URLQueryItem(name: "id", value: "\(id)"))}

        areaID.forEach({ urlComponents.queryItems?.append(URLQueryItem(name: "area_id[]", value: "\($0)")) })
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
               completion(result)
            }
        }
    }
    
    enum OrderPath: String {
        case main = "main"
        case info = "info"
        case pays = "pays"
        case comments = "comments"

    }
    
    
    func fetchOrderMainDetail(id: String, token: String? ,completion: @escaping(Result<GetOrderMainModel, APIError>) -> Void) {
        
        var urlComponents = self.mainUrlComponents
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(.init(name: "id", value: id))
//        urlComponents.queryItems?.append(.init(name: "id", value: "30139"))
//        urlComponents.queryItems?.append(.init(name: "token", value: "f936d2edd686ed3ac795fdd1e31b47fd"))
        
        if let token = token { urlComponents.queryItems?.append(.init(name: "token", value: token))}
        urlComponents.path = urlComponents.path + "/mobile-order/main"
        
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
        }
    }
    
    
    func fetchOrderPayDetail(id: String, token: String? ,completion: @escaping(Result<GetOrderPayModel, APIError>) -> Void) {
        
        var urlComponents = self.mainUrlComponents
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(.init(name: "id", value: id))
//        urlComponents.queryItems?.append(.init(name: "id", value: "30139"))
//        urlComponents.queryItems?.append(.init(name: "token", value: "f936d2edd686ed3ac795fdd1e31b47fd"))
        
        if let token = token { urlComponents.queryItems?.append(.init(name: "token", value: token))}
        urlComponents.path = urlComponents.path + "/mobile-order/pays"
        
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
               completion(result)
            }
        }
    }
    
    
    func fetchOrderInfoDetail(id: String, token: String? ,completion: @escaping(Result<GetOrderInfoModel, APIError>) -> Void) {
        
        var urlComponents = self.mainUrlComponents
        urlComponents.queryItems = []
        urlComponents.path = urlComponents.path + "/mobile-order/info"
        urlComponents.queryItems?.append(.init(name: "id", value: id))
//        urlComponents.queryItems?.append(.init(name: "id", value: "30139"))
//        urlComponents.queryItems?.append(.init(name: "token", value: "f936d2edd686ed3ac795fdd1e31b47fd"))
        
        if let token = token {urlComponents.queryItems?.append(.init(name: "token", value: token))}
        
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
               completion(result)
            }
        }
    }
    
    
    func fetchOrderCommentDetail(id: String, token: String? ,completion: @escaping(Result<GetOrderCommentsModel, APIError>) -> Void) {
        
        var urlComponents = self.mainUrlComponents
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(.init(name: "id", value: "\(id)"))
//        urlComponents.queryItems?.append(.init(name: "id", value: "30139"))
//        urlComponents.queryItems?.append(.init(name: "token", value: "f936d2edd686ed3ac795fdd1e31b47fd"))

        
        if let token = token { urlComponents.queryItems?.append(.init(name: "token", value: token))}
        urlComponents.path = urlComponents.path + "/mobile-order/comments"
        
        
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
               completion(result)
            }
        }
    }
    
    func fetchOrderHints(id: String, completion: @escaping(Result<GetOrderHintsModel, APIError>) -> Void) {
          let token = realm.objects(TokensRealmModel.self).first?.accessToken
          var urlComponents = self.mainUrlComponents
          urlComponents.queryItems = []
          urlComponents.queryItems?.append(.init(name: "id", value: "\(id)"))
          urlComponents.queryItems?.append(.init(name: "token", value: token))
          urlComponents.path = urlComponents.path + "/mobile-order/finance-form-data"
          
          
          if let url = urlComponents.url?.absoluteString {
              networkDataFetcher.fetchGenericJsonData(urlString: url) { (result) in
                 completion(result)
              }
          }
      }
    
        func fetchOrderDetailFromUrl(url: String, completion: @escaping (Result<GetOrderDetailFromUrlModel, APIError>) -> Void) {
          
            networkDataFetcher.fetchGenericJsonData(urlString: url) { (list) in
                completion(list)
            }

      }
    
    enum OrderType: String {
        case home = "area-list"
        case places = "places"
    }
    
    func fetchAreaList(orderId: Int, type: OrderType, completion: @escaping (Result<GetOrderAreaListModel, APIError>) -> Void) {
        let url = "/api/mobile-order/" + type.rawValue + "?id=\(orderId)"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    func fetchPackageList(orderId: Int, completion: @escaping (Result<GetOrderChangePackageModel, APIError>) -> Void) {
        ///Test
//        let url = "https://rsttur.ru/api/mobile-order/places?id=\(orderId)&dev=DIMA-DEV-15-18&token=f936d2edd686ed3ac795fdd1e31b47fd"
        let url = "https://rsttur.ru/api/mobile -order/places?id=\(orderId)"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    func fetchHomeList(orderId: Int, areaId: String, completion: @escaping (Result<GetOrderHomeListModel, APIError>) -> Void) {
        let url = "/api/mobile-order/home-list?id=\(orderId)&area_id=\(areaId)"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    
    //MARK: Arrival
    enum ArrivalType: String {
        case arrivalIn = "/mobile/check-in-list"
        case arrivalOut = "/mobile/check-out-list"
    }
    
    
    func fetchArrivalTourists(date: String, page: Int?, baseId: Int?, areaid: [Int],tab: [GetTabsModel.Param]?, quickSearch: String?, type: ArrivalType, completion: @escaping(Result<GetArrivalModel, APIError>) -> Void) ->  URLSessionDataTask? {
        
        var urlComponents = self.mainUrlComponents
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(.init(name: "date", value: date))
        
        if let page = page { urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let baseId = baseId { urlComponents.queryItems?.append(.init(name: "base_id", value: "\(baseId)")) }
        areaid.forEach({ urlComponents.queryItems?.append( URLQueryItem( name: "area_id[]", value: "\($0)") ) } )

        if let quickSearch = quickSearch { urlComponents.queryItems?.append(.init(name: "CheckOrderSearch[quickSearch]", value: "\(quickSearch)")) }
        if let tab = tab {
            tab.forEach({
                if let name = $0.name, let value = $0.value {
                    urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
                }
            })
        }
        urlComponents.path = urlComponents.path + type.rawValue
        
        if let url = urlComponents.url?.absoluteString {
            return networkDataFetcher.fetchGenericJsonData(urlString: url) { (list) in
                completion(list)
            }
        } else {
            return nil
        }
    }

    // MARK:- Finance
    func fetchFinanceCompanyBalance(id: Int, start: String?, end: String?, completion: @escaping(Result<GetFinanceCompanyBalanceModel, APIError>) -> Void) {
        
        var url = "https://rsttur.ru/api/mobile/unit-balance?id=\(id)"
        
        if let start = start {
            url += "&start=\(start)"
        }
        
        if let end = end {
            url += "&end=\(end)"
        }
        
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }


    func fetchFinanceCompanies(completion: @escaping(Result<GetFinanceCompanyListModel, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/unit-list"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    func fetchFinanceOperations(companyId: Int, completion: @escaping(Result<GetFinanceButtonModel, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/finance-button?id=\(companyId)"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    func fetchFinanceDetail(id: Int, completion: @escaping(Result<GetFinanceDetailModel, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/finance-view?id=\(id)"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    func fetchFinanceList(page: Int?, id: Int, date: String?, search: String?, tab: [GetTabsModel.Param]?, completion: @escaping(Result<GetFinanceListModel, APIError>) -> Void) -> URLSessionDataTask?{

        var urlComponents = self.mainUrlComponents
        urlComponents.path = urlComponents.path + "/mobile/finance-list"
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name: "id", value: "\(id)"))
        
        if let page = page { urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let date = date { urlComponents.queryItems?.append(URLQueryItem(name: "FinanceSerch[date]", value: "\(date)"))}
        if let search = search {urlComponents.queryItems?.append(URLQueryItem(name: "FinanceSerch[quickSearch]", value: search))}
        tab?.forEach({
            if let name = $0.name, let value = $0.value {
                urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
            }
        })
        guard let url = urlComponents.url?.absoluteString else {completion(.failure(.badURL)); return nil}
        return networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    
    func fetchFinanceAutocompleteHints(url: String, query: String?, completion: @escaping(Result<GetHintFromUrlModel, APIError>) -> Void) -> URLSessionDataTask? {
        var urlComponents = URLComponents(string: url)
        if let query = query, !query.isEmpty { urlComponents?.queryItems?.append(URLQueryItem(name: "query", value: "\(query)")) }
        return networkDataFetcher.fetchGenericJsonData(urlString: urlComponents?.url?.absoluteString, completion: completion)
    }

    //MARK: Profile
    func fetchProfile(completion: @escaping(Result<GetProfileModel, APIError>) -> Void) {
        let url = "https://rsttur.ru/api/mobile/user"
        networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion) 
        
    }
    

    func fetchNoticed(type: NoticeType?,page: Int,completion: @escaping(Result<GetNoticedModel, APIError>) -> Void) -> URLSessionDataTask? {
        var url = "https://rsttur.ru/api/mobile/notice-list?page=\(page)"
        if let type = type { url += "&type=\(type.rawValue)"}
        return networkDataFetcher.fetchGenericJsonData(urlString: url, completion: completion)
    }
    
}
*/
