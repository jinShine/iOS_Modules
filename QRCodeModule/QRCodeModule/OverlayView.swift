//
//  OverlayView.swift
//  QRCodeModule
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import UIKit


class OverlayView: UIView {


    // Set from parent
//    let scannerPosition: ScannerPosition!
//    weak var focusView: UIView!
//
//
//
//    // MARK: Life Cycle
//    init(_ scannerPosition: ScannerPosition, focusView: UIView) {
//        self.scannerPosition = scannerPosition
//        self.focusView = focusView
//        super.init(frame: .zero)
//
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }


    func addMask() {

        // Style
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

//        mask(withRect: focusView.frame, inverse: true)
    }
}
