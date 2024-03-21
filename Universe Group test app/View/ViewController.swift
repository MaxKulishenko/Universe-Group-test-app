//
//  ViewController.swift
//  Universe Group test app
//
//  Created by Maksym on 19.03.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private var currentImageView: UIImageView?
    private var actionButtonsContainerView: UIStackView? = nil
    private var movePhotoToTrashButton: UIButton? = nil
    private var showNextPhotoButton: UIButton? = nil
    private var trashContainerView: UIStackView?
    private var trashViewCounter: UILabel?
    private var trashViewLabel: UILabel?
    private var trashViewButton: UIButton?
    private var wrapperView: UIView?
    
    private var presenter: PhotoPresenter?
    
    private var counterValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PhotoPresenter(view: self, photoManager: PhotoManager())
        
        view.backgroundColor = #colorLiteral(red: 0.051, green: 0.0588, blue: 0.1137, alpha: 1)
        
        setupUI()
        
        presenter?.fetchLatestPhoto()
    }
}

extension ViewController: PhotoView {
    func didTapEmptyTrash() {
        counterValue = 0
    }
    
    func updateTrashCounter() {
        trashViewCounter?.text = String(counterValue)
    }
    
    func display(photo: Photo?) {
        guard let photo = photo else {
            currentImageView?.image = nil
            
            return
        }
        
        currentImageView?.image = photo.image
    }
}

//UI
extension ViewController {
    
    private func setupUI() {
        setupTrashViewCounter()
        setupTrashViewLabel()
        setupTrashViewButton()
        setupTrashContainerView()
        setupButtons()
        setupActionButtonsContainerView()
        setupWrapperView()
        setupImageView()
        
        guard let trashContainerView = trashContainerView else { return }
        
        view.addSubview(trashContainerView)
        
        trashContainerView.translatesAutoresizingMaskIntoConstraints = false
        trashContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: -50).isActive = true
        trashContainerView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                  constant: -20).isActive = true
        trashContainerView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                 constant: 20).isActive = true
        trashContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        guard let currentImageView = currentImageView else { return }
        
        view.addSubview(currentImageView)
        
        currentImageView.translatesAutoresizingMaskIntoConstraints = false
        currentImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                              constant: 80).isActive = true
        currentImageView.bottomAnchor.constraint(equalTo: trashContainerView.topAnchor,
                                                 constant: -50).isActive = true
        currentImageView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                               constant: 40).isActive = true
        currentImageView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                constant: -40).isActive = true
        
        guard let wrapperView = wrapperView else { return }
        
        currentImageView.addSubview(wrapperView)
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: currentImageView.topAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: currentImageView.bottomAnchor).isActive = true
        wrapperView.leftAnchor.constraint(equalTo: currentImageView.leftAnchor).isActive = true
        wrapperView.rightAnchor.constraint(equalTo: currentImageView.rightAnchor).isActive = true
        
        guard let actionButtonsContainerView = actionButtonsContainerView else { return }
        
        wrapperView.addSubview(actionButtonsContainerView)
        
        actionButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        actionButtonsContainerView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        actionButtonsContainerView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        actionButtonsContainerView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -30).isActive = true
        
    }
    
    private func setupTrashViewCounter() {
        trashViewCounter = UILabel()
        trashViewCounter?.text = "0"
        trashViewCounter?.textAlignment = .center
        trashViewCounter?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        trashViewCounter?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    private func setupTrashViewLabel() {
        trashViewLabel = UILabel()
        trashViewLabel?.lineBreakMode = .byWordWrapping
        trashViewLabel?.numberOfLines = 0
        trashViewLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        trashViewLabel?.text = "images in the trash"
        trashViewLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        trashViewLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTrashViewButton() {
        trashViewButton = UIButton()
        
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .large
        config.image = UIImage(systemName: "trash",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePlacement = .leading
        config.imagePadding = 8.0
        config.title = "Empty Trash"
        config.baseBackgroundColor = #colorLiteral(red: 0.3137, green: 0.3373, blue: 0.498, alpha: 1)
        config.baseForegroundColor = #colorLiteral(red: 0.6353, green: 0.6549, blue: 0.8196, alpha: 1)
        
        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleFont
        ]
        let attributedTitle = NSAttributedString(string: "Empty Trash",
                                                 attributes: attributes)
        config.attributedTitle = .init(attributedTitle)
        
        trashViewButton?.configuration = config
        trashViewButton?.addTarget(self,
                                   action: #selector(emptyTrashButtonPressed(_:)),
                                   for: .touchUpInside)
    }
    
    private func setupTrashContainerView() {
        guard let trashViewCounter = trashViewCounter,
              let trashViewLabel = trashViewLabel,
              let trashViewButton = trashViewButton else { return }
        
        trashViewLabel.contentMode = .scaleToFill
        
        let containerView = UIStackView()
        containerView.backgroundColor = #colorLiteral(red: 0.1922, green: 0.2, blue: 0.3294, alpha: 1)
        containerView.layer.cornerRadius = 30
        containerView.axis = .horizontal
        containerView.spacing = 10
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.addArrangedSubview(trashViewCounter)
        containerView.addArrangedSubview(trashViewLabel)
        containerView.addArrangedSubview(trashViewButton)
        containerView.layoutMargins = UIEdgeInsets(top: 20,
                                                   left: 20,
                                                   bottom: 20,
                                                   right: 20)
        containerView.isLayoutMarginsRelativeArrangement = true
        trashViewButton.widthAnchor.constraint(equalTo: containerView.widthAnchor,
                                               multiplier: 0.5).isActive = true
        
        trashContainerView = containerView
    }
    
    private func setupImageView() {
        currentImageView = UIImageView()
        currentImageView?.contentMode = .scaleAspectFill
        currentImageView?.layer.cornerRadius = 20
        currentImageView?.layer.masksToBounds = true
        currentImageView?.isUserInteractionEnabled = true
    }
    
    private func setupButtons() {
        movePhotoToTrashButton = UIButton()
        
        var movePhotoToTrashButtonConfig = UIButton.Configuration.gray()
        movePhotoToTrashButtonConfig.cornerStyle = .dynamic
        movePhotoToTrashButtonConfig.image = UIImage(systemName: "trash",
                                                     withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        movePhotoToTrashButtonConfig.imagePadding = 8.0
        movePhotoToTrashButtonConfig.baseBackgroundColor = #colorLiteral(red: 0.9882, green: 0.1412, blue: 0.0392, alpha: 1)
        movePhotoToTrashButtonConfig.baseForegroundColor = .white
        
        movePhotoToTrashButton?.configuration = movePhotoToTrashButtonConfig
        
        movePhotoToTrashButton?.layer.cornerRadius = 30
        movePhotoToTrashButton?.layer.masksToBounds = true
        movePhotoToTrashButton?.translatesAutoresizingMaskIntoConstraints = false
        movePhotoToTrashButton?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        movePhotoToTrashButton?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        movePhotoToTrashButton?.addTarget(self, action: #selector(movePhotoToTrashPressed(_:)),
                                          for: .touchUpInside)
        
        showNextPhotoButton = UIButton()
        
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .dynamic
        config.image = UIImage(systemName: "checkmark",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePadding = 8.0
        config.baseBackgroundColor = #colorLiteral(red: 0.4, green: 0.7765, blue: 0.7137, alpha: 1)
        config.baseForegroundColor = .white
        config.buttonSize = .large
        
        showNextPhotoButton?.layer.cornerRadius = 30
        showNextPhotoButton?.layer.masksToBounds = true
        showNextPhotoButton?.translatesAutoresizingMaskIntoConstraints = false
        showNextPhotoButton?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        showNextPhotoButton?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        showNextPhotoButton?.configuration = config
        
        showNextPhotoButton?.addTarget(self, action: #selector(showNextPhotoPressed(_:)),
                                       for: .touchUpInside)
    }
    
    private func setupActionButtonsContainerView() {
        guard let movePhotoToTrashButton = movePhotoToTrashButton,
              let showNextPhotoButton = showNextPhotoButton else { return }
        
        actionButtonsContainerView = UIStackView()
        actionButtonsContainerView?.layer.cornerRadius = 20
        actionButtonsContainerView?.axis = .horizontal
        actionButtonsContainerView?.alignment = .fill
        actionButtonsContainerView?.distribution = .equalSpacing
        actionButtonsContainerView?.layoutMargins = UIEdgeInsets(top: 0,
                                                                 left: 50,
                                                                 bottom: 0,
                                                                 right: 50)
        actionButtonsContainerView?.isLayoutMarginsRelativeArrangement = true
        
        actionButtonsContainerView?.addArrangedSubview(movePhotoToTrashButton)
        actionButtonsContainerView?.addArrangedSubview(showNextPhotoButton)
    }
    
    private func setupWrapperView() {
        wrapperView = UIView()
        wrapperView?.layer.cornerRadius = 20
    }
}

extension ViewController {
    @objc private func showNextPhotoPressed(_ sender: Any) {
        presenter?.fetchNextLatestPhoto()
    }
    
    @objc private func movePhotoToTrashPressed(_ sender: Any) {
        if let presenter = presenter, presenter.isPhotosLeft {
            counterValue += 1
            presenter.deletePhoto()
        }
    }
    
    @objc private func emptyTrashButtonPressed(_ sender: Any) {
        presenter?.decreasePhotosCounterInTrasView()
    }
}
