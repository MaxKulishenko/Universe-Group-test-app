//
//  PhotoPresenter.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Foundation

class PhotoPresenter {
    private weak var view: PhotoView?
    private let photoManager: PhotoManager
    
    init(view: PhotoView, photoManager: PhotoManager) {
        self.view = view
        self.photoManager = photoManager
    }
    
    func fetchLatestPhoto() {
        if let latestPhoto = photoManager.fetchLatestPhoto() {
            view?.display(photo: latestPhoto)
        }
    }
    
    func deletePhoto(_ photo: Photo) {
        photoManager.deletePhoto(photo)
        fetchLatestPhoto()
    }
    
    func savePhoto() {
        fetchLatestPhoto()
    }
}
