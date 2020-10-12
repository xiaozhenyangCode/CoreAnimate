//
//  CacheViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/10/12.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
  缓存
  如果有很多张图片要显示，最好不要提前把所有都加载进来，而是应该当移出屏幕之后立刻销毁。通过选择性的缓存，你就可以避免来回滚动时图片重复性的加载了。

  缓存其实很简单：就是存储昂贵计算后的结果（或者是从闪存或者网络加载的文件）在内存中，以便后续使用，这样访问起来很快。问题在于缓存本质上是一个权衡过程 - 为了提升性能而消耗了内存，但是由于内存是一个非常宝贵的资源，所以不能把所有东西都做缓存。

  何时将何物做缓存（做多久）并不总是很明显。幸运的是，大多情况下，iOS都为我们做好了图片的缓存。

  +imageNamed:方法

  之前我们提到使用[UIImage imageNamed:]加载图片有个好处在于可以立刻解压图片而不用等到绘制的时候。但是[UIImage imageNamed:]方法有另一个非常显著的好处：它在内存中自动缓存了解压后的图片，即使你自己没有保留对它的任何引用。

  对于iOS应用那些主要的图片（例如图标，按钮和背景图片），使用[UIImage imageNamed:]加载图片是最简单最有效的方式。在nib文件中引用的图片同样也是这个机制，所以你很多时候都在隐式的使用它。

  但是[UIImage imageNamed:]并不适用任何情况。它为用户界面做了优化，但是并不是对应用程序需要显示的所有类型的图片都适用。有些时候你还是要实现自己的缓存机制，原因如下：

 [UIImage imageNamed:]方法仅仅适用于在应用程序资源束目录下的图片，但是大多数应用的许多图片都要从网络或者是用户的相机中获取，所以[UIImage imageNamed:]就没法用了。

 [UIImage imageNamed:]缓存用来存储应用界面的图片（按钮，背景等等）。如果对照片这种大图也用这种缓存，那么iOS系统就很可能会移除这些图片来节省内存。那么在切换页面时性能就会下降，因为这些图片都需要重新加载。对传送器的图片使用一个单独的缓存机制就可以把它和应用图片的生命周期解耦。

 [UIImage imageNamed:]缓存机制并不是公开的，所以你不能很好地控制它。例如，你没法做到检测图片是否在加载之前就做了缓存，不能够设置缓存大小，当图片没用的时候也不能把它从缓存中移除。

  自定义缓存

  构建一个所谓的缓存系统非常困难。菲尔 卡尔顿曾经说过：“在计算机科学中只有两件难事：缓存和命名”。

  如果要写自己的图片缓存的话，那该如何实现呢？让我们来看看要涉及哪些方面：

  选择一个合适的缓存键 - 缓存键用来做图片的唯一标识。如果实时创建图片，通常不太好生成一个字符串来区分别的图片。在我们的图片传送带例子中就很简单，我们可以用图片的文件名或者表格索引。

  提前缓存 - 如果生成和加载数据的代价很大，你可能想当第一次需要用到的时候再去加载和缓存。提前加载的逻辑是应用内在就有的，但是在我们的例子中，这也非常好实现，因为对于一个给定的位置和滚动方向，我们就可以精确地判断出哪一张图片将会出现。

  缓存失效 - 如果图片文件发生了变化，怎样才能通知到缓存更新呢？这是个非常困难的问题（就像菲尔 卡尔顿提到的），但是幸运的是当从程序资源加载静态图片的时候并不需要考虑这些。对用户提供的图片来说（可能会被修改或者覆盖），一个比较好的方式就是当图片缓存的时候打上一个时间戳以便当文件更新的时候作比较。

  缓存回收 - 当内存不够的时候，如何判断哪些缓存需要清空呢？这就需要到你写一个合适的算法了。幸运的是，对缓存回收的问题，苹果提供了一个叫做NSCache通用的解决方案。

  NSCache

  NSCache和NSDictionary类似。你可以通过-setObject:forKey:和-object:forKey:方法分别来插入，检索。和字典不同的是，NSCache在系统低内存的时候自动丢弃存储的对象。

  NSCache用来判断何时丢弃对象的算法并没有在文档中给出，但是你可以使用-setCountLimit:方法设置缓存大小，以及-setObject:forKey:cost:来对每个存储的对象指定消耗的值来提供一些暗示。

  指定消耗数值可以用来指定相对的重建成本。如果对大图指定一个大的消耗值，那么缓存就知道这些物体的存储更加昂贵，于是当有大的性能问题的时候才会丢弃这些物体。你也可以用-setTotalCostLimit:方法来指定全体缓存的尺寸。

  NSCache是一个普遍的缓存解决方案，我们创建一个比传送器案例更好的自定义的缓存类。（例如，我们可以基于不同的缓存图片索引和当前中间索引来判断哪些图片需要首先被释放）。但是NSCache对我们当前的缓存需求来说已经足够了；没必要过早做优化。

  使用图片缓存和提前加载的实现来扩展之前的传送器案例，然后来看看是否效果更好.
 果然效果更好了！当滚动的时候虽然还有一些图片进入的延迟，但是已经非常罕见了。缓存意味着我们做了更少的加载。这里提前加载逻辑非常粗暴，其实可以把滑动速度和方向也考虑进来，但这已经比之前没做缓存的版本好很多了。
 */

let imageTag = 99
class CacheViewController: BaseViewController, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    var imagePaths = [String]()
    var cache = NSCache<AnyObject, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundlePath = Bundle.main.path(forResource: "Vacation", ofType: "")
        do {
            let filesArray = try FileManager.default.contentsOfDirectory(atPath: bundlePath ?? "")
            for file in filesArray {
                imagePaths.append(bundlePath! + "/" + file)
            }
        } catch {
        }
        for _ in 0 ... 5 {
            for item in imagePaths {
                imagePaths.append(item)
            }
        }
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)

        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView?.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        imageView?.image = loadImageAtIndex(indexPath.row, cell)
        if indexPath.row < imagePaths.count - 1 {
            _ = loadImageAtIndex(indexPath.row + 1, cell)
        }
        if indexPath.row > 0 {
            _ = loadImageAtIndex(indexPath.row - 1, cell)
        }
        return cell
    }

    func loadImageAtIndex(_ index: Int, _ cell: UICollectionViewCell) -> UIImage? {
        let image = cache.object(forKey: NSNumber(value: index))
        if image != nil {
            if image is NSNull {
                return nil
            }
            return image as? UIImage
        }
        cache.setObject(NSNull(), forKey: NSNumber(value: index))
        DispatchQueue.global().async {
            let imagePath = self.imagePaths[index]
            var image = UIImage(contentsOfFile: imagePath)
            UIGraphicsBeginImageContextWithOptions(image!.size, true, 0)
            image!.draw(at: .zero)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                self.cache.setObject(image!, forKey: NSNumber(value: index))
                let imageView = cell.contentView.subviews.last as? UIImageView
                imageView?.image = image
            }
        }
        return nil
    }
}
