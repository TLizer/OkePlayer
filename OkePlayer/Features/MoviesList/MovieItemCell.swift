//
//  MovieItemCell.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit

class MovieItemCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bind(with viewModel: MovieCellViewModel) {
        textLabel?.text = viewModel.title
        imageView?.image = viewModel.thumbnail ?? UIImage(named: "movie_thumbnail")?.withRenderingMode(.alwaysTemplate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageView?.frame.size.width = 60
    }
    
    private func setupUI() {
        guard let imageView = imageView, let label = textLabel else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.6).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        //        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        let topConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        topConstraint.priority = UILayoutPriority.defaultLow
        topConstraint.isActive = true
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.gray
        imageView.tintColor = .black
    }
}
