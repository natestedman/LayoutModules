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

class ViewController: UIViewController
{
    override func loadView()
    {
        let layout = LayoutModulesCollectionViewLayout(majorAxis: .Vertical, moduleForSection: { [unowned self] section in
            return self.modules[section]
        })
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        self.view = collectionView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "LayoutModules"
    }
    
    let modules = [
        LayoutModule.table(majorDimension: 44, padding: 1),
        LayoutModule.dynamicTable(padding: 1, calculateMajorDimension: { index, _ in
            CGFloat((index + 1) * 10)
        }),
        LayoutModule.grid(minimumMinorDimension: 20, padding: Size(major: 10, minor: 10)).inset(minMajor: 10),
        LayoutModule.masonry(
            minimumMinorDimension: 80,
            padding: Size(major: 1, minor: 1),
            calculateMajorDimension: { index, width in
                return round(2 / (CGFloat(index % 4) + 1) * width)
            }
        ).inset(minMajor: 10, maxMajor: 10, minMinor: 10, maxMinor: 10),
        LayoutModule.grid(minimumMinorDimension: 50, padding: Size(major: 10, minor: 10), aspectRatio: 4.0 / 3.0)
    ]
}

extension ViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return modules.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 3
        {
            return 30
        }
        else
        {
            return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.grayColor()
        return cell
    }
}
