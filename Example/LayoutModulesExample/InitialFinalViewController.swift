// LayoutModules
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import LayoutModules
import UIKit

class InitialFinalViewController: UIViewController
{
    private var collectionView: UICollectionView?
    
    override func loadView()
    {
        let module = LayoutModule
            .masonry(
                minimumMinorDimension: 80,
                padding: Size(major: 1, minor: 1),
                calculateMajorDimension: { index, _, minorDimension in
                    return round(1 / (CGFloat(index % 4) + 1) * minorDimension)
                }
            )
            .inset(10)
            .withInitialTransition({ _, attributes in
                var mutableAttributes = attributes
                mutableAttributes.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), 1)
                mutableAttributes.alpha = 0
                return mutableAttributes
            })
            .withFinalTransition({ _, attributes in
                var mutableAttributes = attributes
                mutableAttributes.transform = CGAffineTransformMakeScale(0.9, 0.1)
                mutableAttributes.alpha = 0
                return mutableAttributes
            })
        
        let layout = LayoutModulesCollectionViewLayout(majorAxis: .Vertical, moduleForSection: { _ in module })
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        self.view = collectionView
        self.collectionView = collectionView
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(InitialFinalViewController.timerAction(_:)), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    private var timer: NSTimer?
    private var increasing = true
    private var count = 0
    
    @objc private func timerAction(sender: AnyObject?)
    {
        if count == 0
        {
            increasing = true
        }
        else if count == 30
        {
            increasing = false
        }
        
        if increasing
        {
            count += 1
            collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: count - 1, inSection: 0)])
        }
        else
        {
            count -= 1
            collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: count, inSection: 0)])
        }
    }
}

extension InitialFinalViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.grayColor()
        return cell
    }
}
