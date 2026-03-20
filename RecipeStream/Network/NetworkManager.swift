//
//  NetworkManager.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    /// Single from RxSwift
    func request<T: Decodable>(_ route: URLRequestConvertible) -> Single<T> {
        return Single.create { single in
            let request = AF.request(route)
                .validate() /// to confirm if response (Status Code)  200...299
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
