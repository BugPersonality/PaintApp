//
//  ViewController.swift
//  DrawingApp
//
//  Created by Данил Дубов on 01.04.2021.
//

import UIKit

// MARK: - main vc code

class CanvasViewController: UIViewController {

    var canvas = Canvas()
        
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        button.addTarget(self, action: #selector(handleUndoButton), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clear"), for: .normal)
        button.addTarget(self, action: #selector(handleClcButton), for: .touchUpInside)
        return button
    }()
    
    let colorPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(handleColorPickerButton), for: .touchUpInside)
        return button
    }()
    
    let widthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "scribble"), for: .normal)
        button.addTarget(self, action: #selector(handleWidthButton), for: .touchUpInside)
        return button
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.isHidden = true
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(handleSliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    let rubber: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.tophalf.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleRubberButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "CanvasVCBackgroundImage")!)
        canvas.backgroundColor = .white
        setupLayout()
        setupVCHead()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        canvas.setNeedsDisplay()
    }
    
    func putCanvas(canvas: Canvas) {
        self.canvas = canvas
    }
}

// MARK: - Setup gesture for canvas

extension CanvasViewController: UIGestureRecognizerDelegate {
    func addGestureToCanvasView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 2
        panGesture.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotationGesture(_:)))
        rotateGesture.delegate = self
        
        canvas.isUserInteractionEnabled = true
        canvas.isMultipleTouchEnabled = true
        
        canvas.frame = CGRect(x: 100, y: 50, width: 500, height: 500)
        
        canvas.addGestureRecognizer(panGesture)
        canvas.addGestureRecognizer(pinchGesture)
        canvas.addGestureRecognizer(rotateGesture)
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    @objc func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            if let view = sender.view {
                view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
            }
        }
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Setup color picker delegate

extension CanvasViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        self.colorPickerButton.backgroundColor = color
        canvas.lineColor = color
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        self.colorPickerButton.backgroundColor = color
        canvas.lineColor = color
    }
}

// MARK: - objc processing functions

extension CanvasViewController {
    @objc fileprivate func handleRubberButton() {
        let color = canvas.backgroundColor
        canvas.lineColor = color!
    }
    
    @objc fileprivate func handleClcButton() {
        let alert = UIAlertController(title: "Delete all ?", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.canvas.clear()
        })
        
        let noAction = UIAlertAction(title: "No", style: .destructive, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
        
    }
    
    @objc fileprivate func handleUndoButton() {
        canvas.undo()
    }
    
    @objc fileprivate func handleColorPickerButton() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    @objc fileprivate func handleSliderValueChanged() {
        canvas.strokeWidht = Double(slider.value)
        if slider.value >= 5 {
            widthButton.setImage(UIImage(systemName: "scribble.variable"), for: .normal)
        } else {
            widthButton.setImage(UIImage(systemName: "scribble"), for: .normal)
        }
    }
    
    @objc fileprivate func handleWidthButton() {
        UIView.animate(withDuration: 0.4) {
            if self.slider.isHidden == false {
                self.slider.isHidden = true
            } else {
                self.slider.isHidden = false
            }
        }
    }
    
    @objc fileprivate func handleSaveButton() {
        let image = canvas.getCanvasViewAsUIImage()
        let items = [image]
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let excludeActivities: [UIActivity.ActivityType] =
            [
                .airDrop,
                .addToReadingList,
                .copyToPasteboard,
                .mail,
                .message,
            ]
        
        activityVC.excludedActivityTypes = excludeActivities

        self.present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - UI things

extension CanvasViewController {
    fileprivate func setupVCHead() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveButton))
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.1450768709, green: 0.1451098919, blue: 0.1450772882, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    fileprivate func setupLayout() {
        let controllPanel: UIStackView = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton,
            colorPickerButton,
            rubber,
            widthButton,
            slider
        ])
        
        self.view.addSubview(canvas)
        view.addSubview(controllPanel)
        view.bringSubviewToFront(controllPanel)
        
        controllPanel.distribution = .fillProportionally
        controllPanel.spacing = 16
        
        controllPanel.backgroundColor = #colorLiteral(red: 0.1450768709, green: 0.1451098919, blue: 0.1450772882, alpha: 1)
        controllPanel.layer.cornerRadius = 16
        
        controllPanel.translatesAutoresizingMaskIntoConstraints = false
        controllPanel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        controllPanel.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        controllPanel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        controllPanel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        controllPanel.alignment = .center
        
        colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        colorPickerButton.heightAnchor.constraint(equalTo: controllPanel.heightAnchor, constant: -30).isActive = true
        colorPickerButton.widthAnchor.constraint(equalTo: colorPickerButton.heightAnchor, multiplier: 1).isActive = true
            
        canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: self.view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: controllPanel.topAnchor),
        ])
        
        addGestureToCanvasView()
    }
}
