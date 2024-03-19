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
    private var deleteButton: UIButton? = nil
    private var aproveButton: UIButton? = nil
    private var trashContainerView: UIStackView?
    private var trashViewCounter: UILabel?
    private var trashViewLabel: UILabel?
    private var trashViewButton: UIButton?
    private var wrapperView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.051, green: 0.0588, blue: 0.1137, alpha: 1)
        
        setupUI()
    }
}

extension ViewController: PhotoView {
    func display(photo: Photo) {
        currentImageView?.image = photo.image
    }
}

extension ViewController: EmptyCartView {
    func didTapEmptyTrash() {
        return  //
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
        
        setupImageView()
        
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
        trashViewButton?.translatesAutoresizingMaskIntoConstraints = false
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
        trashViewButton.widthAnchor.constraint(equalTo: containerView.widthAnchor , multiplier: 0.5).isActive = true

        trashContainerView = containerView
    }
    
    private func setupImageView() {
        currentImageView = UIImageView()
       // currentImageView?.backgroundColor = .white
        currentImageView?.image = UIImage(named: "immage")
        currentImageView?.layer.cornerRadius = 20
        currentImageView?.layer.masksToBounds = true
    }
    
    private func setupButtons() {
        deleteButton = UIButton()
        
        var deleteButtonConfig = UIButton.Configuration.gray()
        deleteButtonConfig.cornerStyle = .dynamic
        deleteButtonConfig.image = UIImage(systemName: "trash",
              withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        deleteButtonConfig.imagePadding = 8.0
        deleteButtonConfig.baseBackgroundColor = #colorLiteral(red: 0.9882, green: 0.1412, blue: 0.0392, alpha: 1)
        deleteButtonConfig.baseForegroundColor = .white
        
        deleteButton?.configuration = deleteButtonConfig
        
        deleteButton?.layer.cornerRadius = 30
        deleteButton?.layer.masksToBounds = true
        deleteButton?.translatesAutoresizingMaskIntoConstraints = false
        deleteButton?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        deleteButton?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        aproveButton = UIButton()
        
        guard let aproveButton = aproveButton else { return }
        
        var aprroveButtonConfig = UIButton.Configuration.gray()
        aprroveButtonConfig.cornerStyle = .dynamic
        aprroveButtonConfig.image = UIImage(systemName: "checkmark",
              withConfiguration: UIImage.SymbolConfiguration(scale: .large))
       // trashButtonConfig.imagePlacement = .
        aprroveButtonConfig.imagePadding = 8.0
        //aprroveButtonConfig.title = "Empty Trash"
        aprroveButtonConfig.baseBackgroundColor = #colorLiteral(red: 0.4, green: 0.7765, blue: 0.7137, alpha: 1)
        aprroveButtonConfig.baseForegroundColor = .white
        aprroveButtonConfig.buttonSize = .large
        
        aproveButton.configuration = aprroveButtonConfig
        
        aproveButton.layer.cornerRadius = 30
        aproveButton.layer.masksToBounds = true
        aproveButton.translatesAutoresizingMaskIntoConstraints = false
        aproveButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        aproveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    private func setupActionButtonsContainerView() {
        guard let deleteButton = deleteButton,
              let approveButton = aproveButton else { return }
        actionButtonsContainerView = UIStackView()
        
        //actionButtonsContainerView?.backgroundColor = .green
        actionButtonsContainerView?.layer.cornerRadius = 20
        actionButtonsContainerView?.axis = .horizontal
        actionButtonsContainerView?.alignment = .fill
        actionButtonsContainerView?.distribution = .equalSpacing
        actionButtonsContainerView?.layoutMargins = UIEdgeInsets(top: 0,
                                                   left: 50,
                                                   bottom: 0,
                                                   right: 50)
        actionButtonsContainerView?.isLayoutMarginsRelativeArrangement = true
        
        actionButtonsContainerView?.addArrangedSubview(deleteButton)
        actionButtonsContainerView?.addArrangedSubview(approveButton)
    }
    
    private func setupWrapperView() {
        wrapperView = UIView()
        wrapperView?.alpha = 1
        wrapperView?.layer.cornerRadius = 20
    }
}
