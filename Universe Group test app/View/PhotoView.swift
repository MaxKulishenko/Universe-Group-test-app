//
//  PhotoView.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import Foundation

protocol PhotoView: AnyObject {
    func display(photo: Photo)
    func updateTrashCounter()
}
