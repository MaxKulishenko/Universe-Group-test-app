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
    func fetchLatestPhoto() -> AnyPublisher<Photo, Error> {
        return Future<Photo, Error> { promise in
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    promise(.failure(PhotoError.accessDenied))
                    
                    return
                }
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                guard let latestAsset = fetchResult.firstObject else {
                    promise(.failure(PhotoError.noPhotosFound))
                    
                    return
                }
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = false
                requestOptions.deliveryMode = .highQualityFormat
                
                PHImageManager.default().requestImage(for: latestAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { image, _ in
                    guard let image = image else {
                        promise(.failure(PhotoError.imageFetchFailed))
                        
                        return
                    }
                    
                    let photo = Photo(image: image, date: latestAsset.creationDate ?? Date())
                    promise(.success(photo))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deletePhoto(_ photo: Photo) {
    }
    
    func emptyCart() {
    }
}

extension PhotoManager {
    enum PhotoError: Error {
        case accessDenied
        case noPhotosFound
        case imageFetchFailed
    }
}
