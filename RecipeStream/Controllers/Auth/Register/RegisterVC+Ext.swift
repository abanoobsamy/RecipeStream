//
//  RegisterViewController.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import PhotosUI
internal import RxRelay

extension RegisterVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // check if user click (Cancel)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    userIV.image = image
                    viewModel.selctedImage.accept(image)
                    userIV.contentMode = .scaleAspectFill
                }
            }
        }
    }
}
