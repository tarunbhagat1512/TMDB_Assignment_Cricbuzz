//
//  MovListCell.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import UIKit

class MovListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var PosterImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var durRatLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    private var movieId: Int = 0
        var onFavoriteToggled: ((Int, Bool) -> Void)?

        override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }

        private func setupUI() {
            PosterImg.layer.borderColor = UIColor.systemGray.cgColor
            PosterImg.layer.borderWidth = 1.0
            PosterImg.layer.cornerRadius = 15
            PosterImg.clipsToBounds = true
            PosterImg.contentMode = .scaleAspectFill
            // Ensure button touch area is comfortable
            favBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

        func configure(data: MovieDetails) {
            self.movieId = data.id ?? -1
            titleLbl.text = data.title ?? "Unknown"
            let vote = data.vote_average ?? 0.0
            durRatLbl.text = "★ \(String(data.vote_average!))"

            if let posterPath = data.poster_path,
               let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                self.PosterImg.loadImage(from: imageURL)
            } else {
                self.PosterImg.image = UIImage(systemName: "film")
            }

            updateFavoriteUI()
        }

        private func updateFavoriteUI() {
            guard movieId > 0 else {
                favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                favBtn.tintColor = .label
                return
            }
            let isFav = StoreFavHelper.shared.isFavorite(movieId)
            let symbol = isFav ? "heart.fill" : "heart"
            favBtn.setImage(UIImage(systemName: symbol), for: .normal)
            favBtn.tintColor = isFav ? .systemRed : .label
            // Accessibility
            favBtn.accessibilityLabel = isFav ? "Remove from favorites" : "Add to favorites"
        }
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        guard movieId > 0 else { return }
                // Toggle directly in the store so the state always changes
                StoreFavHelper.shared.toggle(movieId)
                // Update UI immediately
                updateFavoriteUI()
                // Inform VC (pass id and current favorite state)
                let nowFav = StoreFavHelper.shared.isFavorite(movieId)
                onFavoriteToggled?(movieId, nowFav)
    }
    
}
