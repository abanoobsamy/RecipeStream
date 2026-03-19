//
//  ImageUploadService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import UIKit
import RxSwift

class ImageUploadService: ImageUploadServiceProtocol {
    
    // حط الـ API Key بتاعك هنا (أو في ملف الـ Constants)
    private let apiKey = Constants.Keys.apiKeyImageBB
    
    // الدالة دي بتاخد الصورة، وترجعلك الـ URL بتاعها على النت
    func uploadImage(image: UIImage) -> Single<String> {
        return Single.create { single in
            
            // 1. نحول الصورة لـ Data ونضغطها شوية (0.5 يعني جودة 50%)
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                single(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Faild to convert image to data"])))
                return Disposables.create()
            }
            
            // 2. نحول الداتا لـ نص (Base64) عشان نبعتها في الـ API
            let base64Image = imageData.base64EncodedString()
            
            // 3. نجهز الـ Request
            let urlString = "https://api.imgbb.com/1/upload?key=\(self.apiKey)"
            guard let url = URL(string: urlString) else { return Disposables.create() }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // 4. نجهز الـ Body
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
            body.append(base64Image.data(using: .utf8)!)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            NetworkLogger.log(request: request)
            
            // 5. نبعت الـ Request للسيرفر (باستخدام مسار آمن لسويفت 6)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else { single(.failure(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response data"]))); return }
                                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDict = json["data"] as? [String: Any],
                       let imageUrl = dataDict["url"] as? String {
                        
                        NetworkLogger.log(response: response, data: json, error: error)

                        single(.success(imageUrl))
                        
                    } else {
                        single(.failure(NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to read image data from response"])))
                    }
                } catch {
                    single(.failure(error))
                }
                
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

