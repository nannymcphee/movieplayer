//
//  PlayerControlView.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit

protocol PlayerControlViewDelegate: class {
    
}

class PlayerControlView: UIView {
    // MARK: - IBOUTLETS
    
    
    
    
    // MARK: - VARIABLES
    weak var delegate: PlayerControlViewDelegate?
    
    
    
    // MARK: - OVERRIDES
    override func awakeFromNib() {
        configureView()
    }
    
    // MARK: - PUBLIC FUNCTIONS
    static func makeInstance(with delegate: PlayerControlViewDelegate) -> PlayerControlView {
        let nib = UINib(nibName: "PlayerControlView", bundle: nil)
        guard let controlView = nib.instantiate(withOwner: nil, options: nil).first as? PlayerControlView else {
            return PlayerControlView()
        }
        controlView.delegate = delegate
        return controlView
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func configureView() {
        
    }
    
    // MARK: - ACTIONS
    @IBAction func didTapOnButtonPlay(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapOnButtonFullscreen(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapOnButtonNext(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapOnButtonPrev(_ sender: UIButton) {
        
    }
    
}
