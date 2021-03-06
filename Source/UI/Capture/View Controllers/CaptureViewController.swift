//
//  CaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/25/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import AVFoundation
import Cartography
import GPUImage

final class CaptureViewController: UIViewController {

    // MARK: - View Lifecycle

    private var videoCamera: Camera?
    override func loadView() {
        super.loadView()
        view.accessibilityIdentifier = "CaptureView"
        view.backgroundColor = UIColor.black

        renderViewSetup()
        controlsSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if Platform.isSimulator {
            placeholderSetup()
        } else {
            cameraSetup()
        }
    }

    // MARK: - Render

    private var renderView: RenderView!
    fileprivate func renderViewSetup() {
        renderView = RenderView(frame: view.bounds)
        renderView.fillMode = .preserveAspectRatioAndFill
        view.addSubview(renderView)
    }

    // MARK: - Camera Setup

    fileprivate func cameraSetup() {
        do {
            videoCamera = try Camera(sessionPreset: AVCaptureSessionPresetPhoto, location: .backFacing)
        } catch {
            print("Couldn't initialize camera, error: \(error)")
        }

        guard let videoCamera = videoCamera else {
            return
        }

        videoCamera.addTarget(renderView)
        videoCamera.startCapture()
    }

    // MARK: - Placeholder

    fileprivate func placeholderSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.insertSubview(imageView, at: 0)
    }

    // MARK: - Controls Setup

    private lazy var captureButton: CaptureButton = CaptureButton()
    fileprivate func controlsSetup() {
        captureButton.setTappedCallback(instance: self,
                                        method: Method.captureTapped)
        view.addSubview(captureButton)

        constrain(captureButton) {
            let superview = $0.superview!
            $0.width == 75
            $0.height == $0.width
            $0.centerX == superview.centerX
            $0.bottom == superview.bottom - 15
        }
    }

    // MARK: - Capturing

    fileprivate func captureTapped() {
        print("capture tapped")
    }

    // MARK: - Status Bar

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

// MARK: - Callbacks

fileprivate struct Method {
    static let captureTapped = CaptureViewController.captureTapped

}
