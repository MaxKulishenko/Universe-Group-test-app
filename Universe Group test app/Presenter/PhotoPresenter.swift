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
        guard let photo = latestFetchedPhoto else { return }
        photoManager.deletePhoto(photo)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self?.view?.updateTrashCounter()
                    }
                    self?.fetchNextLatestPhoto()
                case .failure(let error):
                    print("Error deleting photo: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
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
    
    func decreasePhotosCounterInTrasView() {
        photoManager.emptyCart()
            .sink(receiveCompletion: {  completion in
                switch completion {
                case .failure(let error):
                    print("Error deleting photos: \(error.localizedDescription)")
                   
                    if !self.photoManager.trashBin.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.display(photo: self?.latestFetchedPhoto)
                    }
                    }
                case .finished:
                    if self.photoManager.trashBin.isEmpty {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.display(photo: nil)
                        }
                    }
                }
            }, receiveValue: { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    self?.view?.didTapEmptyTrash()
                    self?.view?.updateTrashCounter()
                }
            })
            .store(in: &cancellables)
    }
}
