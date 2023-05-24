//
//  TagListView.swift
//  TheMET
//
//  Created by Анна Ситникова on 17/05/2023.
//

import Foundation
import UIKit

typealias TagView = UIButton

class TagListView: UIView {
    
    var tags: [String] = [] {
        didSet {
            self.updateTags()
        }
    }
    var maxNumberOfLines: Int = 2 {
        didSet {
            self.updateTags()
        }
    }
    
    private let showMoreTagsButton = UIButton()
    private var tagViews: [TagView] = []
    
    private let tagsXSpacing: CGFloat = 12
    private let tagsYSpacing: CGFloat = 10
    
    private let offsetByX: CGFloat = 0
    private let offsetByY: CGFloat = 0
    
    private var totalHeight: CGFloat = 0 {
        didSet {
            self.bounds = CGRect(origin: self.bounds.origin,
                                 size: CGSize.init(width: self.bounds.width,
                                                   height: self.totalHeight))
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: self.totalHeight)
    }
    
    override var bounds: CGRect {
        didSet {
            guard self.bounds.width != oldValue.width else { return }
            self.updateTags()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showMoreTagsButton.apply(radius: 0, backgroundColor: .clear , fontColor: UIColor(named: "blueberry"), font: NSLocalizedString("serif_font", comment: ""), fontSize: 14, buttonTitle: NSLocalizedString("button_title.show_more_tags_cta", comment: ""))
        self.showMoreTagsButton.addTarget(self, action: #selector(showMoreButtonDidTap), for: .touchUpInside)
        self.showMoreTagsButton.frame = CGRect(origin: .zero,
                                               size: self.showMoreTagsButton.intrinsicContentSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let estimatedHeight: CGFloat = self.calculateLayout(for: size.width).height
        return CGSize(width: size.width, height: estimatedHeight)
    }
    
    @objc
    private func showMoreButtonDidTap() {
        self.maxNumberOfLines = .max
    }
    
    typealias frameData = (tagViewFrames: [CGRect], showMoreButtonFrame: CGRect?, height: CGFloat)
    
    
    private func calculateLayout(for width: CGFloat) -> frameData {
        var result: frameData = frameData(tagViewFrames: [], showMoreButtonFrame: .zero, height: 0)
        guard width > 0 else {
            return result
        }
        guard self.tagViews.count != 0 else {
            return result
        }
        var x: CGFloat = self.offsetByX
        var y: CGFloat = self.offsetByY
        let xSpace: CGFloat = self.tagsXSpacing
        let ySpace: CGFloat = self.tagsYSpacing
        var lineNumber: Int = 0
    throughTags: for (tagViewIndex, tagView) in tagViews.enumerated() {
        if lineNumber < self.maxNumberOfLines - 1 {
            if tagView.bounds.width > width - x {
                lineNumber += 1
                y += tagView.bounds.height + ySpace
                x = self.offsetByX
            }
            if lineNumber == self.maxNumberOfLines - 1,
               tagView.bounds.width > self.showMoreTagsButton.bounds.width {
                
            } else {
                result.tagViewFrames.append(CGRect(x: x, y: y, width: tagView.bounds.width, height: tagView.bounds.height))
                x += tagView.bounds.width + xSpace
            }
        } else {
            let restTagsWidth = self.tagsWidth(from: tagViewIndex, to: self.tagViews.count - 1, xSpace: xSpace)
            if restTagsWidth < width {
                let restTagsFrames:[CGRect] = self.setRestTagsFrames(from: tagViewIndex, to: self.tagViews.count - 1, xSpace: xSpace, ySpace: ySpace, x: x, y: y)
                result.tagViewFrames.append(contentsOf: restTagsFrames)
                break throughTags
            } else {
                let restTagsAndShowMoreButtonFrames = self.setRestTagsAndShowMoreButtonFrames(from: tagViewIndex, to: self.tagViews.count - 1, xSpace: xSpace, ySpace: ySpace, x: x, y: y)
                result.tagViewFrames.append(contentsOf: restTagsAndShowMoreButtonFrames.tagViewFrames)
                result.showMoreButtonFrame = restTagsAndShowMoreButtonFrames.showMoreButton
                break throughTags
            }
        }
    }
        self.totalHeight = self.tagViews[0].bounds.height * CGFloat(lineNumber + 1) + ySpace * CGFloat(lineNumber)
        result.height = self.totalHeight
        return result
    }
    
    private func updateTags() {
        self.showMoreTagsButton.removeFromSuperview()
        for tagView in self.tagViews {
            tagView.removeFromSuperview()
        }
        self.tagViews = []
        var newTagViews: [TagView] = []
        for tag in self.tags {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            let newTagView = TagView(configuration: configuration)
            newTagView.setTitle(tag, for: .normal)
            newTagViews.append(newTagView)
            newTagView.translatesAutoresizingMaskIntoConstraints = false
            newTagView.frame = CGRect(origin: .zero,
                                      size: newTagView.intrinsicContentSize)
            newTagView.translatesAutoresizingMaskIntoConstraints = true
            newTagView.autoresizingMask = [ .flexibleRightMargin, .flexibleBottomMargin ]
        }
        self.tagViews = newTagViews
        self.layoutTagViews()
    }
    
    private func layoutTagViews() {
        let visibleTags:[CGRect] = self.calculateLayout(for: self.bounds.width).tagViewFrames
        let visibleTagsCount = visibleTags.count
    throughTags: for (tagViewIndex, tagView) in tagViews.enumerated() {
        if tagViewIndex < visibleTagsCount {
            self.addSubview(tagView)
            tagView.apply(radius: 15, backgroundColor: UIColor(named: "plum"), fontColor: UIColor(named: "blackberry"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 13, buttonTitle: (self.tagViews[tagViewIndex].titleLabel?.text)!)
            let tagFrameOrigin = self.calculateLayout(for: self.bounds.width).tagViewFrames[tagViewIndex].origin
            tagView.frame.origin = tagFrameOrigin
        }
    }
        if let showMoreButtonFrame = self.calculateLayout(for: self.bounds.width).showMoreButtonFrame,
           showMoreButtonFrame.width != 0 {
            self.addSubview(self.showMoreTagsButton)
            self.showMoreTagsButton.frame.origin = showMoreButtonFrame.origin
        }
        self.invalidateIntrinsicContentSize()
    }
    
    private func tagsWidth(from index1: Int, to index2: Int, xSpace: CGFloat) -> CGFloat {
        var result: CGFloat = 0
        for index in index1 ... index2 {
            let tagView = self.tagViews[index]
            result += tagView.bounds.width
        }
        result += xSpace * CGFloat(index2 - index1) + self.tagViews[index1 - 1].bounds.width
        return result
    }
    
    private func setRestTagsFrames(from index1: Int, to index2: Int, xSpace: CGFloat, ySpace: CGFloat, x: CGFloat, y: CGFloat) -> [CGRect] {
        var tagViewFrames: [CGRect] = []
        var xCoord: CGFloat = x
        for index in index1 ... index2 {
            let tagView = self.tagViews[index]
            tagViewFrames.append(CGRect(x: xCoord, y: y, width: tagView.bounds.width, height: tagView.bounds.height))
            xCoord += tagView.bounds.width + xSpace
        }
        return tagViewFrames
    }
    
    private func setRestTagsAndShowMoreButtonFrames(from index1: Int, to index2: Int, xSpace: CGFloat, ySpace: CGFloat, x: CGFloat, y: CGFloat) -> (tagViewFrames: [CGRect], showMoreButton: CGRect) {
        var result: ([CGRect], CGRect) = ([], .zero)
        var xCoord: CGFloat = x
        for index in index1 ... index2 {
            let tagView = self.tagViews[index]
            if tagView.bounds.width > self.bounds.width - xCoord - self.showMoreTagsButton.bounds.width {
                self.showMoreTagsButton.frame.origin = CGPoint(x: xCoord, y: y)
                result.1  = CGRect(x: xCoord, y: y, width: showMoreTagsButton.bounds.width, height: showMoreTagsButton.bounds.height)
                return result
            } else {
                result.0.append(CGRect(x: xCoord, y: y, width: tagView.bounds.width, height: tagView.bounds.height))
                tagView.frame.origin = CGPoint(x: xCoord, y: y)
                xCoord += tagView.bounds.width + xSpace
            }
        }
        return result
    }
}
