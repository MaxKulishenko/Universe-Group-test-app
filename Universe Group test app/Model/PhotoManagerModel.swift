//
//  PhotoManagerModel.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Foundation
import Photos
import Combine

final class PhotoManager {
    private var trashBin: [Photo] = []
    
    func fetchNextLatestPhoto(before date: Date? = nil) -> AnyPublisher<Photo, Error> {
        return Future<Photo, Error> { promise in
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    promise(.failure(PhotoError.accessDenied))
                    
                    return
                }
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                 ascending: true)]
                
                if let date = date {
                    fetchOptions.predicate = NSPredicate(format: "creationDate < %@",
                                                         date as CVarArg)
                }
                
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                guard let nextLatestAsset = fetchResult.lastObject else {
                    promise(.failure(PhotoError.noPhotosFound))
                    
                    return
                }
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = false
                requestOptions.deliveryMode = .highQualityFormat
                
                PHImageManager.default().requestImage(for: nextLatestAsset,
                                                         targetSize: PHImageManagerMaximumSize,
                                                         contentMode: .aspectFit,
                                                         options: requestOptions) { image, _ in
                    guard let image = image else {
                        promise(.failure(PhotoError.imageFetchFailed))
                        
                        return
                    }
                    
                    let photo = Photo(image: image,
                                      date: nextLatestAsset.creationDate ?? Date(),
                                      localIdentifier: nextLatestAsset.localIdentifier)
                    promise(.success(photo))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deletePhoto(_ photo: Photo) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            // Move photo to trash bin
            self?.trashBin.append(photo)
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    func emptyCart() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            if self.trashBin.isEmpty {
                promise(.failure(PhotoError.noPhotosFound))
            }
            
            let localIdentifiers = self.trashBin.map { $0.localIdentifier }
            
            PHPhotoLibrary.shared().performChanges {
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers,
                                                 options: nil)
                PHAssetChangeRequest.deleteAssets(assets)
            } completionHandler: { success, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(success))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

extension PhotoManager {
    enum PhotoError: Error {
        case accessDenied
        case noPhotosFound
        case imageFetchFailed
    }
}
