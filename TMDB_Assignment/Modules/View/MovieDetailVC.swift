//
//  MovieDetailVC.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation
import UIKit
import WebKit


class MovieDetailVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var trailerVew: UIView!
    @IBOutlet weak var ratingLBL: UILabel!
    @IBOutlet weak var generesLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var castLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieID: Int?
    private let viewModel = MovieDetailsViewModel()
    private var webView: WKWebView!
    
    private var youtubeKey: String?
    private var videos: [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupWebView()
        
        if let id = movieID, id > 0 {
            observeEvent()
            viewModel.fetchMovieDetail(id: id)
            viewModel.fetchTrailer(id: id)
        } else {
            showErrorMessage("Invalid movie ID")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = trailerVew.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayback()
    }
    
    // MARK: - Public configure (call before presenting or after init)
    func configure(with videos: [Video]) {
        self.videos = videos
        if isViewLoaded {
            handleVideos(videos)
        }
    }
    
    // MARK: - Setup WKWebView
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            config.requiresUserActionForMediaPlayback = false
        }
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isOpaque = false
        webView.backgroundColor = .black
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        trailerVew.addSubview(webView)
        webView.frame = trailerVew.bounds
    }
    
    // MARK: - Handle videos array & selection
    private func handleVideos(_ videos: [Video]) {
        guard !videos.isEmpty else {
            showNoVideoAvailable()
            return
        }
        
        guard let key = selectYouTubeKey(from: videos) else {
            showNoVideoAvailable()
            return
        }
        youtubeKey = key
        loadYouTubeVideo(key: key)
    }
    
    private func selectYouTubeKey(from results: [Video]) -> String? {
        // 1. Prefer official Trailer
        if let trailer = results.first(where: { ($0.type?.lowercased() == "trailer") && ($0.official ?? false) }) {
            return trailer.key
        }
        // 2. Else prefer first official
        if let official = results.first(where: { $0.official ?? false }) {
            return official.key
        }
        // 3. Else prefer first Trailer (even if not official)
        if let trailerAny = results.first(where: { $0.type?.lowercased() == "trailer" }) {
            return trailerAny.key
        }
        // 4. Fallback to first result's key
        return results.first?.key
    }
    
    // MARK: - Load YouTube embed into webView
    private func loadYouTubeVideo(key: String) {
        let embed = "https://www.youtube.com/embed/\(key)?playsinline=1&autoplay=1&mute=1"
        guard let url = URL(string: embed) else { return }
        let req = URLRequest(url: url)
        webView.load(req)
    }
    
    // MARK: - Helpers / Alerts
    private func showNoVideoAvailable() {
        let alert = UIAlertController(title: "No trailer", message: "No trailer or video available to play.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Optional: reload or stop
    func reloadVideo() {
        if let key = youtubeKey {
            loadYouTubeVideo(key: key)
        }
    }
    
    func stopPlayback() {
        webView.evaluateJavaScript("document.querySelector('video')?.pause();", completionHandler: nil)
    }
    
    // MARK: - UI updates
    func updateUI() {
        if let genres = viewModel.Details?.genres, !genres.isEmpty {
            let genreNames = genres.map { $0.name ?? "" }.joined(separator: ", ")
            generesLbl.text = genreNames
        } else {
            generesLbl.text = "N/A"
        }
        
        ratingLBL.text = "★ \(String((viewModel.Details?.voteAverage) ?? 0))"
        descriptionLbl.text = viewModel.Details?.overview
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "caseCell", bundle: nil), forCellWithReuseIdentifier: "caseCell")
    }
    
    private func showErrorMessage(_ message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("[WKWebView] started provisional navigation")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("[WKWebView] finished navigation")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("[WKWebView] didFail navigation: \(error.localizedDescription)")
        showWebError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("[WKWebView] didFailProvisionalNavigation: \(error.localizedDescription)")
        showWebError(error)
    }

    // helper to show user-friendly alert
    private func showWebError(_ error: Error) {
        let ac = UIAlertController(title: "Playback error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: - ViewModel events
extension MovieDetailVC {
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                print("Data Loading")
            case .stopLoading:
                print("Data Stopped Loading")
            case .dataLoaded:
                print("Data Loaded")
            case .error(let error):
                print(error)
            case .movieDetailFetched(data: let data):
                print(data)
                self.viewModel.Details = data
                DispatchQueue.main.async {
                    self.title = data.title
                    self.updateUI()
                }
            case .trailerFetched(data: let data):
                // `data` should be [Video] from your viewModel
                DispatchQueue.main.async {
                    self.configure(with: data)
                }
            }
        }
    }
}

// MARK: - CollectionView
extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "caseCell", for: indexPath) as! caseCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: (collectionView.bounds.height) - 16)
    }
}
