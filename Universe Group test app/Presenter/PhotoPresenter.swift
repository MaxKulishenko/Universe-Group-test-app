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
    public var isPhotosLeft: Bool = false
    
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
                    self.isPhotosLeft = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] photo in
                self?.isPhotosLeft = true
                self?.latestFetchedPhoto = photo
                self?.view?.display(photo: photo)
            })
            .store(in: &cancellables)
    }
    
    func deletePhoto() {
        photoManager.fetchNextLatestPhoto(before: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching latest photo: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { photo in
                guard let latestFetchedPhoto = self.latestFetchedPhoto else { return }
                
                self.photoManager.deletePhoto(latestFetchedPhoto)
                    .sink { [ weak self] completion in
                        
                        switch completion {
                        case .finished:
                            DispatchQueue.main.async { [weak self] in
                                self?.increasePhotosInTrashCounter()
                                self?.fetchNextLatestPhoto()
                            }
                        case .failure(let error):
                            print("Deletion failed: \(error.localizedDescription)")
                        }
                    } receiveValue: { _ in }
                    .store(in: &self.cancellables )
            })
            .store(in: &cancellables)
    }
    
    func fetchNextLatestPhoto() {
        guard let latestFetchedPhoto = latestFetchedPhoto else { return }
        
        photoManager.fetchNextLatestPhoto(before: latestFetchedPhoto.date)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching latest photo: \(error.localizedDescription)")
                    self.isPhotosLeft = false
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.display(photo: nil)
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] photo in
                self?.latestFetchedPhoto = photo
                self?.view?.display(photo: photo)
                self?.isPhotosLeft = true
            })
            .store(in: &cancellables)
    }
    
    func increasePhotosInTrashCounter() {
        view?.updateTrashCounter()
    }
}
