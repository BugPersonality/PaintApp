//
//  CanvasView.swift
//  DrawingApp
//
//  Created by Данил Дубов on 01.04.2021.
//

import UIKit

class Canvas: UIView {
    var image: UIImage?
    
    var strokeWidht: Double = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var lineColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    fileprivate var lines: [Line] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
            { return }
        
        lines.forEach() { line in
            context.setStrokeColor(line.lineColor.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.butt)
            
            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            
            context.strokePath()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else
            { return }
        
        guard var lastLine = lines.popLast() else
            { return }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(strokeWidth: strokeWidht, lineColor: lineColor, points: []))
    }
    
    func undo() {
        guard !lines.isEmpty else
            { return }
        lines.removeLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
}

extension Canvas {
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }

    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else
            { return }
        print(scale)
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    func getImage() -> UIImage?{
        UIGraphicsBeginImageContext(bounds.size)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    func getCanvasViewAsUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


