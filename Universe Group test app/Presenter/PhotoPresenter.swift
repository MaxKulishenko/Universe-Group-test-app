//
//  PhotoPresenter.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Combine
import Foundation

final class PhotoPresenter {
    private weak var view: PhotoView?
    private let photoManager: PhotoManager
    private var cancellables: Set<AnyCancellable> = []
    private var latestFetchedPhoto: Photo?
    
    init(view: PhotoView, photoManager: PhotoManager) {
        self.view = view
        self.photoManager = photoManager
    }
    
    func fetchLatestPhoto() {
        photoManager.fetchNextLatestPhoto(before: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching latest photo: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] photo in
                self?.latestFetchedPhoto = photo
                self?.view?.display(photo: photo)
            })
            .store(in: &cancellables)
    }
    
    func deletePhoto(_ photo: Photo) {
        photoManager.deletePhoto(photo)
        fetchLatestPhoto()
    }
    
    func fetchNextLatestPhoto() {
        guard let latestFetchedPhoto = latestFetchedPhoto else { return }
        
        photoManager.fetchNextLatestPhoto(before: latestFetchedPhoto.date)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching latest photo: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] photo in
                self?.latestFetchedPhoto = photo
                self?.view?.display(photo: photo)
            })
            .store(in: &cancellables)
    }
}
