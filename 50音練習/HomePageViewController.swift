//
//  ViewController.swift
//  50音練習
//
//  Created by 陳韋綸 on 2022/3/19.
//

import UIKit
import AVFoundation

class HomePageViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private let changeToneBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("変更しよ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    private let speakStartBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
        button.setTitle("スタート", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("タイム", for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.layer.masksToBounds = true
        return button
    }()
    
    private let speakToneLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.clipsToBounds = true
        label.textAlignment = .center
        label.backgroundColor = .label
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 80, weight: .bold)
        return label
    }()

    var toneBool: Bool = true
    var tone = [String]()
    var time: Timer? = nil
    var y: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toneBoolChange()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: HomePageCollectionViewCell.identifier)
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView!)
        view.addSubview(changeToneBtn)
        view.addSubview(speakStartBtn)
        view.addSubview(speakToneLabel)
        
        changeToneBtn.addTarget(self, action: #selector(didTapChangeTone), for: .touchUpInside)
        speakStartBtn.addTarget(self, action: #selector(didTapSpeakStart), for: .touchUpInside)
    }
    
    @objc private func didplus() {
        let utten = AVSpeechUtterance(string: tone[y])
        speakToneLabel.text = tone[y]
        y += 1
        collectionView?.reloadData()
        utten.voice = AVSpeechSynthesisVoice(language: "ja-JP")
       let model = AVSpeechSynthesizer()
        model.speak(utten)
    }
    
    @objc private func didTapSpeakStart() {
        if time == nil {
            speakStartBtn.isSelected = true
            y = 0
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(didplus), userInfo: nil, repeats: true)
        }
        else {
            speakStartBtn.isSelected = false
            y = 0
            speakToneLabel.text = ""
            collectionView?.reloadData()
            time?.invalidate()
            time = nil
        }
    }
    
    @objc private func didTapChangeTone() {
        toneBool = !toneBool
        toneBoolChange()
    }
    
    func toneBoolChange() {
        if toneBool {
            tone = Tone.shared.hiraganaTone()
        }
        else {
            tone = Tone.shared.katakanaTone()
        }
        collectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height-100)
        changeToneBtn.frame = CGRect(x: view.right-100, y: view.bottom-100, width: 80, height: 80)
        speakStartBtn.frame = CGRect(x: 20, y: view.bottom-100, width: 80, height: 80)
        speakToneLabel.frame = CGRect(x: (speakStartBtn.left-changeToneBtn.right-120)/2+changeToneBtn.right, y: view.bottom-140, width: 120, height: 120)
        
        changeToneBtn.layer.cornerRadius = changeToneBtn.width/2
        speakStartBtn.layer.cornerRadius = speakStartBtn.width/2
        speakToneLabel.layer.cornerRadius = speakToneLabel.width/2
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/6, height: view.width/6)
        layout.scrollDirection = .vertical 
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tone.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.identifier, for: indexPath) as? HomePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == y - 1 {
            cell.configure(word: tone[indexPath.row], select: true)
        }
        else {
            cell.configure(word: tone[indexPath.row], select: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        speakStartBtn.isSelected = false
        y = indexPath.row + 1
        collectionView.reloadData()
        time?.invalidate()
        time = nil
        speakToneLabel.text = tone[indexPath.row]
        let utten = AVSpeechUtterance(string: tone[indexPath.row])
        utten.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        let model = AVSpeechSynthesizer()
        model.speak(utten)
    }
}
