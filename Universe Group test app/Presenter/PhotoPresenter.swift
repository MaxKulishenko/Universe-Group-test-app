//
//  PhotoPresenter.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Combine

final class PhotoPresenter {
    private weak var view: PhotoView?
    private let photoManager: PhotoManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(view: PhotoView, photoManager: PhotoManager) {
        self.view = view
        self.photoManager = photoManager
    }
    
    func fetchLatestPhoto() {
        photoManager.fetchLatestPhoto()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching latest photo: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] photo in
                self?.view?.display(photo: photo)
            })
            .store(in: &cancellables)
    }
    
    func deletePhoto(_ photo: Photo) {
        photoManager.deletePhoto(photo)
        fetchLatestPhoto()
    }
    
    func savePhoto() {
        fetchLatestPhoto()
    }
}
