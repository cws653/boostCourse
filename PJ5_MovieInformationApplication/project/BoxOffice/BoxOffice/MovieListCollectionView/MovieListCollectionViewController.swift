//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/08/30.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UIViewController {

    private let movieService: MovieServiceProvider = .shared
    private let cellIdentifier = "collectionViewCell"
    var arrayMovies: [Movies] = []

    @IBOutlet private weak var collectionView: UICollectionView?

    @IBAction private func navigationItemAction(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertController.Style.actionSheet)
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self

        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView?.collectionViewLayout = layout
        
        self.movieService.requestMovieList(movieSortMode: .reservationRate) { movies in
            DispatchQueue.main.async {
                self.arrayMovies = movies
                self.collectionView?.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            if let movieListTableViewController = navigationController.viewControllers.first as? MovieListTableViewController {
                movieListTableViewController.arrayMovies = self.arrayMovies
                movieListTableViewController.navigationItem.title = self.navigationItem.title
            }
        }
    }
    
    private func showAlertController (style: UIAlertController.Style) {

        let alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)

        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in print("취소버튼 선택")})
        
        alertController.addAction(alertActionSetting(movieSortMode: .reservationRate))
        alertController.addAction(alertActionSetting(movieSortMode: .quration))
        alertController.addAction(alertActionSetting(movieSortMode: .open))
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: { print("Alert controller shown")})
    }

    private func alertActionSetting(movieSortMode: MovieSortMode) -> UIAlertAction {
        let alertAction = UIAlertAction(title: movieSortMode.title, style: UIAlertAction.Style.default) { _ in
            self.movieService.requestMovieList(movieSortMode: movieSortMode) { movies in
                DispatchQueue.main.async {
                    self.navigationItem.title = movieSortMode.title
                    self.arrayMovies = movies
                    self.collectionView?.reloadData()
                }
            }
        }
        return alertAction
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsViewController {
            movieDetailsViewController.movies = self.arrayMovies[indexPath.item]
            
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MovieListCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:MovieListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model: Movies = self.arrayMovies[indexPath.row]

        guard let imageURL: URL = URL(string: model.thumb) else {
            return UICollectionViewCell()
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data else { return}

            DispatchQueue.main.async {
                cell.setupUI(model: model, data: data)
            }
        }.resume()

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSizeX: CGFloat = collectionView.frame.width / 2 - 1

        return CGSize(width: targetSizeX, height: 2 * targetSizeX)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


