//
//  CanvasCell.swift
//  DrawingApp
//
//  Created by Данил Дубов on 03.04.2021.
//

import UIKit

class CanvasCell: UITableViewCell {
    var canvasImage = UIImageView()
    var canvasLable = UILabel()
    var cellIndex: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(canvasImage)
        addSubview(canvasLable)
        configureLable()
        configureImageView()
        setImageConstraints()
        setLableConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        canvasImage.layer.cornerRadius = 10
        canvasImage.layer.borderColor  = UIColor.black.cgColor
        canvasImage.clipsToBounds      = true
    }
    
    func configureLable() {
        canvasLable.numberOfLines = 0
        canvasLable.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        canvasImage.translatesAutoresizingMaskIntoConstraints                                            = false
        canvasImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                            = true
        canvasImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive              = true
        canvasImage.heightAnchor.constraint(equalToConstant: 80).isActive                                = true
        canvasImage.widthAnchor.constraint(equalTo: canvasImage.heightAnchor, multiplier: 9/16).isActive = true
    }
    
    func setLableConstraints() {
        canvasLable.translatesAutoresizingMaskIntoConstraints                                            = false
        canvasLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                            = true
        canvasLable.leadingAnchor.constraint(equalTo: canvasImage.trailingAnchor, constant: 20).isActive = true
        canvasLable.heightAnchor.constraint(equalToConstant: 80).isActive                                = true
        canvasLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive           = true
    }
    
    func putDataIntoCell(canvas: CanvasCellStruct, indexPath: IndexPath) {
        canvasImage.image = canvas.canvas.getCanvasViewAsUIImage()
        canvasLable.text = canvas.title
        cellIndex = indexPath.row
        setupCellBackgroundColor()
    }
    
    fileprivate func setupCellBackgroundColor() {
        self.backgroundColor = (cellIndex! % 2 != 0) ? .white : UIColor(red: 0.9406142831, green: 0.9567645192, blue: 0.9691721797, alpha: 1)
    }
    
}
