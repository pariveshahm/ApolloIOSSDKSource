//  APIClient.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/22/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.

import Foundation
import Alamofire

typealias ResponseHandler<T> = (T) -> Void
typealias ErrorHandler = (AttServiceError) -> Void

class AttAPIClient {
    
    // - Class properties
    static var alamofireSession: Session?
    
    // - Properties
    var baseURL: String
    
    // - Init
    init() {
        self.baseURL = ""
        AttAPIClient.initAFSession()
    }
    
}

// MARK: - Public properties
extension AttAPIClient {
    
    var commonHeaders: [String: String] {
        let channel = ApolloSDK.current.getChannel()
        return [
            "Content-Type":    "application/json",
            "Accept":          "application/json",
            "country":         ApolloSDK.current.getCountry().rawValue,
            "Accept-Language": ApolloSDK.current.getLanguage().rawValue,
            "host":          ApolloSDK.current.getEnvironment().headerBaseUrl(),
            "tenant":          ApolloSDK.current.getTenantValue().lowercased(),
            "channel":         channel.rawValue.lowercased(),
            "Authorization":   "Bearer \(ApolloSDK.current.getAccessToken() ?? "")",
            "x-app-platform":  "iOS",
            "x-app-version":   "0.10.6"
        ]
    }
    
    var nonAuthHeaders: [String: String] {
        let channel = ApolloSDK.current.getChannel()
        return [
            "Content-Type":    "application/json",
            "Accept":          "application/json",
            "country":         ApolloSDK.current.getCountry().rawValue,
            "Accept-Language": ApolloSDK.current.getLanguage().rawValue,
            "host":          ApolloSDK.current.getEnvironment().headerBaseUrl(),
            "tenant":          ApolloSDK.current.getTenantValue().lowercased(),
            "channel":         channel.rawValue.lowercased(),
            "x-app-platform":  "iOS",
            "x-app-version":   "0.10.6"
        ]
    }
    
    
}

// MARK: - Public Methods
extension AttAPIClient {
    
    func post<T: Decodable, U: Encodable>(path: String, params: [String: Any], headers: [String: String], body: U, responseHandler: @escaping (Result<T, Error>) -> Void) {
        
        var urlRequest = URLRequest(baseUrl: baseURL, path: path, method: .post, params: params)
        urlRequest.timeoutInterval = 120
        let httpHeaders = HTTPHeaders(headers)
        
        urlRequest.headers = httpHeaders
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(body)
            urlRequest.httpBody = jsonData
        } catch {
            responseHandler(.failure(error))
        }
        
        executeRequest(urlRequest: urlRequest, responseHandler: responseHandler)
    }
    
    func post<T: Decodable>(path: String, params: [String: Any], headers: [String: String], body: [String: Any?], responseHandler: @escaping (Result<T, Error>) -> Void) {
        
        var urlRequest = URLRequest(baseUrl: baseURL, path: path, method: .post, params: params)
        urlRequest.timeoutInterval = 120
        let httpHeaders = HTTPHeaders(headers)
        
        urlRequest.headers = httpHeaders
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            urlRequest.httpBody = jsonData
        } catch {
            responseHandler(.failure(error))
        }
        
        executeRequest(urlRequest: urlRequest, responseHandler: responseHandler)
    }
    
    func post<T: Decodable>(path: String, params: [String: Any], headers: [String: String], responseHandler: @escaping (Result<T, Error>) -> Void) {
        
        var urlRequest = URLRequest(baseUrl: baseURL, path: path, method: .post, params: params)
        urlRequest.timeoutInterval = 120
        let httpHeaders = HTTPHeaders(headers)
        
        urlRequest.headers = httpHeaders
        
        executeRequest(urlRequest: urlRequest, responseHandler: responseHandler)
    }
    
    func get<T: Decodable>(path: String, params: [String: Any], headers: [String: String], responseHandler: @escaping (Result<T, Error>)->Void) {
        
        var urlRequest = URLRequest(baseUrl: baseURL, path: path, method: .get, params: params)
        urlRequest.timeoutInterval = 120
        let httpHeaders = HTTPHeaders(headers)
        urlRequest.headers = httpHeaders
        
        executeRequest(urlRequest: urlRequest, responseHandler: responseHandler)
    }
    
}

// MARK: - Private
extension AttAPIClient {
    private func executeRequest<T:Decodable>(urlRequest: URLRequest,
                                             responseHandler: @escaping (Result<T, Error>) -> Void) {
        
        AttAPIClient.alamofireSession?.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self, queue: .main) { response in
                
                switch response.result {
                    case .success(let res):
                            responseHandler(.success(res))
                    case .failure(let mainError):
                        
                        do {
                            guard let serverResponse = response.data else { throw mainError }
                            var serverError = try JSONDecoder().decode(AttServerError.self, from: serverResponse)
                            serverError.httpCode = response.response?.statusCode
                            
                            responseHandler(.failure(serverError))
                            
                        } catch {
                            let statusCode = response.response?.statusCode
                            let serverError = AttServerError(errorMessage: mainError.errorDescription, errorCode: "\(statusCode ?? 0)", httpCode: statusCode)
                            
                            responseHandler(.failure(serverError))
                        }
                        
                    }
            }
            .responseJSON(completionHandler: { (response ) in
            // - Request
            let url     = urlRequest.url?.absoluteString ?? "–"
            let query   = urlRequest.url?.query ?? "–"
            let headers = urlRequest.allHTTPHeaderFields ?? [:]
            let body    = urlRequest.httpBody ?? Data()
            let statusCode = response.response?.statusCode
            print("""

                Request:
                URL:    \(url)
                Code:   \(statusCode ?? 0)
                Query:  \(query)
                Header: \(headers as AnyObject)
                Body:   \(String(data: body, encoding: .utf8) ?? "{ }"))
                
                """)
                
                // Request new token if needed
                if response.response?.statusCode == 401 { ApolloSDK.current.authenticationDelegate?.requestNewToken() }
                
                if(url.contains("ViewPaymentProfile")) {
                    if let creditCard = response.response?.statusCode {
                        ApolloSDK.current.creditCard = creditCard
                    }
                }
                
                if(url.contains("GetDashboard")) {
                    if let cacheTime = (response.response?.headers["Cache-Time"] ?? response.response?.headers["cache-time"]) {
                        ApolloSDK.current.cacheTime = cacheTime
                    }
                }
                
            if let setCookie = response.response?.allHeaderFields["Set-Cookie"] as? String, setCookie.contains("OPENID_PAYLOAD=") {
                let endIndex = setCookie.endIndex(of: "OPENID_PAYLOAD=")!
                let setCookiePart = setCookie[endIndex...]
                let openId: String = String(setCookiePart.split(separator: ";")[0])
                ApolloSDK.current.openIdPayload = openId
            }
                
            // - Response
            guard let data = response.data else { return }
            print("Response:")
            print(String(data: data, encoding: .utf8) ?? "{ }")
            print("\n")
        })
    }
    
    
    func validateJWTFormat(jwt: String?) -> Bool {
        guard let jwt = jwt else {
            return false
        }
        let trimmedJwt = jwt.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedJwt.isEmpty { return false }
        
        let splittedJwt = trimmedJwt.split(separator: ".")
        if splittedJwt.count < 2 { return false }
        
        guard let header = String(splittedJwt[0]).fromBase64(), let body = String(splittedJwt[1]).fromBase64() else { return false }
        
        do {
            let headerDecoded = try JSONDecoder().decode([String: String].self, from: Data(header.utf8))
            let _ = try JSONDecoder().decode([String: String].self, from: Data(body.utf8))
            
            if let _ = headerDecoded["alg"] {
                return true
            }
            
            return false
        } catch {
            return false
        }
    }
    
    private static func initAFSession()  {
        
        alamofireSession = AF
        return
    }
}
