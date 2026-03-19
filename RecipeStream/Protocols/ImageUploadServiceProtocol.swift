//
//  ImageUploadServiceProtocol.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import RxSwift
import UIKit

protocol ImageUploadServiceProtocol {
    func uploadImage(image: UIImage) -> Single<String>
}
