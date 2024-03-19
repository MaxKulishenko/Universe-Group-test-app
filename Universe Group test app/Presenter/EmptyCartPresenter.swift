//
//  EmptyCartPresenter.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Foundation

class EmptyCartPresenter {
    private let photoManager: PhotoManager
    private weak var view: EmptyCartView?
    
    init(view: EmptyCartView, photoManager: PhotoManager) {
        self.view = view
        self.photoManager = photoManager
    }
    
    func emptyCart() {
        photoManager.emptyCart()
    }
}
