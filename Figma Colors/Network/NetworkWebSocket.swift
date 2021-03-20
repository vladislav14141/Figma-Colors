//
//  NetworkWebSocket.swift
//  RST-PMS
//
//  Created by Миронов Влад on 17.09.2020.
//  Copyright © 2020 RST-TUR, OOO. All rights reserved.
//
/*
import Starscream
import Foundation
import Combine
import SwiftUI
class NetworkWebSocket: NSObject {
    private var connectTry = 3
    private var loginTry = 3
    private var lastConnectTryTime = Date()
    private var writeQuery: [String: [String: Any]] = [:]
    private let socketQueue = DispatchQueue(label: "socketQueue", qos: .background)
    
    ///Push-notification used
    var onConnectHandler: (()->Void)?
    
    var isConnected = false
    var responce: PassthroughSubject<WebsocketMessageType, Never>? = PassthroughSubject()
    let networkService = NetworkService()
    let hud = ProgressHUD()
    static var shared = NetworkWebSocket()
    var ownerId: Int?
    var request: URLRequest = {
        var r = URLRequest(url: URL(string: "wss://rsttur.ru/wss2/")!)
        r.timeoutInterval = 5
//        r.
        return r
    }()
    var socket: WebSocket!
    var bag = [AnyCancellable]()
    var topView: UIView? {
        let chat = GlobalRouter.shared.getController(type: .chat)
        return chat?.view
    }
    
    override init() {
        super.init()
        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
        socket.delegate = self

        responce?
            .compactMap({$0})
            .sink(receiveValue: { type in
            self.onDecodeMessage(type: type)
        }).store(in: &bag)
    }
    

    
    func connect() {
            self.updateTriesByDelay()
            guard self.isConnected == false else { return }
            self.socket.connect()
    }
    
    func disconect() {
        guard isConnected else { return }
        socket.disconnect()
    }

    
    func editChannelList(channels: inout [ChatChannelModel], firstWhere: ((ChatChannelModel)->(Bool))) -> (object: ChatChannelModel, index: Int)? {
        guard let index = channels.firstIndex(where: {firstWhere($0)}) else { return nil}
        let object = channels[index]
        return (object, index)
    }
    
    func write(message: [String: Any],  completion: (() -> ())? = nil) {
        if isConnected {
            print("socket write - ", message)
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.socket.write(data: message.toJSON(), completion: {
                    if let completion = completion {
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                })
            }
        } else {
            let type = message["type"] as! String
            writeQuery[type] = message
//            connect()
        }
    }
}

extension NetworkWebSocket: WebSocketDelegate {
    
    fileprivate func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    fileprivate func decodeMessage<T: Codable>(text: String, decodeModel: T.Type, completion: @escaping(Result<T, APIError>) -> Void) {
//        DispatchQueue.global(qos: .utility).async {
            let data = text.data(using: .utf8, allowLossyConversion: true)
            self.decodeJsonData(data, completion: { data in
//                DispatchQueue.main.async {
                    completion(data)
//                }
            })
//        }
    }
    
    fileprivate func decodeJsonData<Y:Codable>(_ jsonData: Data?, completion: @escaping(Result<Y, APIError>) -> Void) {
        guard let jsonData = jsonData else {completion(.failure(.responseError)); return}
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(Y.self, from: jsonData)

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
    
    fileprivate func simpleDecodeMessage<T: Codable>(text: String, decodeModel: T.Type, completion: @escaping (T) -> Void) {
        decodeMessage(text: text, decodeModel: T.self, completion: { [weak self] in
            switch $0 {
                case .success(let success):
                    completion(success)
                case .failure(let err):
                    self?.hud.showError(detail: err.rawValue, in: self?.topView)
            }
        })
    }
    
    fileprivate func getTypeOfMessage(text: String) -> String {
        ///drop {"type":" in  "{"type":"login",\"code\":\"ws-1607575207-rzeyTQPbCjXeL0JT\"}"
        let text = text.dropFirst(9)
        
        var type: String = ""
        for char in text {
            if char == "\"" {
                break
            }
            type += "\(char)"
        }
        return type
    }
    
    func decodeMessages(text: String, messageType: @escaping (WebsocketMessageType)->Void) {

        let type = getTypeOfMessage(text: text)

        let enumType = WebsocketMessageTypeCoder(rawValue: type)
        
        switch enumType {
        case .login:
            self.simpleDecodeMessage(text: text, decodeModel: ChatLoginModel.self, completion: {
                messageType(.login($0))
            })
        case .auth:
            self.simpleDecodeMessage(text: text, decodeModel: ChatAuthModel.self, completion: {
                messageType(.auth($0))
            })
        case .chats:
            self.simpleDecodeMessage(text: text, decodeModel: ChatListModel.self, completion: {
                messageType(.chats($0))
            })
        case .messages:
            self.simpleDecodeMessage(text: text, decodeModel: ChatMessageListModel.self, completion: {
                messageType(.messages($0))
            })
        case .message:
            self.simpleDecodeMessage(text: text, decodeModel: ChatMessagesModel.self, completion: {
                messageType(.message($0))
            })
        case .read:
            self.simpleDecodeMessage(text: text, decodeModel: ChatReadModel.self, completion: {
                messageType(.read($0))
            })
        case .print:
            self.simpleDecodeMessage(text: text, decodeModel: ChatPrintModel.self, completion: {
                messageType(.print($0))
            })
        case .online:
            self.simpleDecodeMessage(text: text, decodeModel: ChatOnlineModel.self, completion: {
                messageType(.online($0))
            })
        case .delete:
            self.simpleDecodeMessage(text: text, decodeModel: ChatDeletedModel.self, completion: {
                messageType(.delete($0))
            })
        case .update:
            self.simpleDecodeMessage(text: text, decodeModel: ChatUpdateModel.self, completion: {
                messageType(.update($0))
            })
        case .searchAll:
            self.simpleDecodeMessage(text: text, decodeModel: ChatSearchAllModel.self, completion: {
                messageType(.searchAll($0))
            })
        case .searchChat:
            self.simpleDecodeMessage(text: text, decodeModel: ChatSearchChannelModel.self, completion: {
                messageType(.searchChat($0))
            })
        case .searchUser:
            self.simpleDecodeMessage(text: text, decodeModel: ChatSearchUserModel.self, completion: {
                messageType(.searchUser($0))
            })
        case .chat:
            self.simpleDecodeMessage(text: text, decodeModel: ChatNewChannelModel.self, completion: {
                messageType(.chat($0))
            })
        case .listUserGroup:
            self.simpleDecodeMessage(text: text, decodeModel: ChatGroupListModel.self, completion: {
                messageType(.listUserGroup($0))
            })
        case .setInfoGroup:
            self.simpleDecodeMessage(text: text, decodeModel: ChatChangeInfoGroupModel.self, completion: {
                messageType(.setInfoGroup($0))
            })
        case .leaveGroup:
            self.simpleDecodeMessage(text: text, decodeModel: ChatLeaveGroupModel.self, completion: {
                messageType(.leaveGroup($0))
            })
        case .error:
            self.simpleDecodeMessage(text: text, decodeModel: ChatErrorModel.self, completion: {
                messageType(.error($0))
            })
        case .links:
            self.simpleDecodeMessage(text: text, decodeModel: ChatLinkModel.self, completion: {
                messageType(.links($0))
            })
        case .media:
            self.simpleDecodeMessage(text: text, decodeModel: ChatMediaModel.self, completion: {
                messageType(.media($0))
            })
        case .documents:
            self.simpleDecodeMessage(text: text, decodeModel: ChatDocumentsModel.self, completion: {
                messageType(.documents($0))
            })

        case .delUserGroup:
            self.simpleDecodeMessage(text: text, decodeModel: ChatDelUserGroupModel.self, completion: {
                messageType(.delUserGroup($0))
            })
        case .setAccess:
            self.simpleDecodeMessage(text: text, decodeModel: ChatSetAccessModel.self, completion: {
                messageType(.setAccess($0))
            })
        case .none:
            hud.showError(detail: "type = \(type)", in: topView)
        }
    }
    
    fileprivate func updateConnectTries() {
        connectTry = 3
        loginTry = 3
    }
    
    fileprivate func updateTriesByDelay() {
        let diff = Date().timeIntervalSince(lastConnectTryTime)
        if diff > 10 {
            updateConnectTries()
            lastConnectTryTime = Date()
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
            switch event {
            case .text(let text):
                print("Socket message - ",text)
                socketQueue.async { [weak self] in
                    self?.decodeMessages(text: text) { [weak self] (type) in
                        DispatchQueue.main.async {
                            self?.responce?.send(type)
                        }
                    }
                }
                
                case .connected(let data):
                    isConnected = true
                     connectTry = 3
                    print("connected", data)
                case .disconnected(let data, let statusCode):
                    isConnected = false
                    print("disconnected", data, statusCode)
                    
                    
                case .binary(let data):
                    print("binary", data)
                case .pong(let data):
                    print("pong", data)
                case .ping(let data):
                    print("ping", data)
                
                case .error(let err):
                    print("socket error", err?.localizedDescription ?? "")
                    isConnected = false
                    handleError(err)
                    
                case .viabilityChanged(let viability):
                    print("viabilityChanged", viability)
                case .reconnectSuggested(let needReconect):
                    if needReconect && connectTry > 0{
                        connect()
                        connectTry -= 1
                    }
                    print("reconnectSuggested", needReconect)


                case .cancelled:
                    isConnected = false

                    print("Canceled")
            }
        }
    func onConnectHandler(_ handler: @escaping (()->Void)) {
        if isConnected {
            handler()
        } else {
            self.onConnectHandler = handler
        }
    }
    
   fileprivate func handleError(_ error: Error?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
            self?.connect()
        })
    }
}

extension NetworkWebSocket {
    fileprivate func onDecodeMessage(type: WebsocketMessageType) {
        switch type {
            case .auth(let auth): onAuth(auth: auth)
            case .login(_): onLogin()
            case .error(let err):
                hud.showError(title: "Type - error", detail: err.message, in: topView)
            default:
                break
        }
    }
    
    fileprivate func onLogin() {
        guard isConnected else {
//            connect()
            return
        }
        loginTry -= 1
        updateTriesByDelay()
        guard loginTry > 0 else { hud.dismiss(); return }
        guard let token = RealmManager.accessToken else { return }
        write(message: ["type": "login", "access_token": token])
    }
    
    fileprivate func onAuth(auth: ChatAuthModel) {
        loginTry = 3
        self.ownerId = auth.userId
        
        writeQuery.values.forEach({
            write(message: $0)
        })
        writeQuery.removeAll()
        
        if let handler = onConnectHandler {
            handler()
            onConnectHandler = nil
        }
    }
}
*/
