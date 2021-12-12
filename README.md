# DragAndDropKit

[![Version](https://img.shields.io/cocoapods/v/DragAndDropKit.svg?style=flat)](https://cocoapods.org/pods/DragAndDropKit)
[![License](https://img.shields.io/cocoapods/l/DragAndDropKit.svg?style=flat)](https://cocoapods.org/pods/DragAndDropKit)
[![Platform](https://img.shields.io/cocoapods/p/DragAndDropKit.svg?style=flat)](https://cocoapods.org/pods/DragAndDropKit)
![Language](https://img.shields.io/badge/language-Swift-DE5C43.svg?style=flat)

iOS15下一行代码集成跨应用间拖拽传递数据(A Simple way help you drop or drag your source (like UIImage) between different App.)

## CocoaPods

```ruby
pod 'DragAndDropKit', '0.2.0'
```

### Drag Usage


#### UIView Drag Usage

最快只需两行代码即可实现拖拽,支持链式写法

```

/*
             你想拖拽时候给予的souce, 目前支持NetworkImageDropSource、NetworkVideoDropSource、ImageDropSource、VideoDropSource、TextDropSource五种
             */
            self.networkImageView.drag.dropSource = NetworkImageDropSource(imageUrl: "http://image.jerryfans.com/sample.jpg")
            
            //开启拖拽
            self.networkImageView.drag.enabled()

```

以及可选协议转链式闭包

```
self.networkImageView.drag.enabled().didEndSession { interaction, session, operation in
                
            }.didMoveSession { interaction, session in
                
            }.didPreviewForDragSession { interaction, item, session in
                return
            }.didAllowsMoveOperationSession { interaction, session in
                return false
            }
```

#### UICollectionView & UITableView Drag Usage

UICollectionView、UITableView因为实习的协议不同，但本质写法是差不多的。
两者enabled后都必须至少实现tableViewDidItemsForBeginning  或 collectionViewDidItemsForBeginning 闭包，返回相应的DragItem。DragItem封装的也是上面所说的5种DropSource。

tableView

```

tableView.drag.enabled().tableViewDidItemsForBeginning { [weak self] tableView, session, indexPath in
                guard let self = self else { return [] }
                //if you are the custom model, you should convert to DropSource Object (Text,Image or Video Drop Source)
                let source = self.models[indexPath.row]
                let itemProvider = NSItemProvider(object: source)
                return [
                    UIDragItem(itemProvider: itemProvider)
                ]
            }

```

collectionView,如果要实现一些生命周期方法，可以实现一下生命周期闭包，同样是链式语法。

```
collectionView.drag.enabled()
            .collectionViewDidItemsForBeginning { [weak self] collectionView, session, indexPath in
                return self?.dragAndDropVM.dragItems(for: indexPath) ?? []
            }.collectionViewWillBeginDragSession { collectionView, session in
                JFPopup.toast(hit: "collection view will begin drag")
            }.collectionViewDidEndDragSession { collectionView, session in
                JFPopup.toast(hit: "collection view did end drag")
            }
```

![](http://image.jerryfans.com/drag_view.gif)   ![](http://image.jerryfans.com/drag_view_1.gif)

### Drop

从其他应用的接收data到到本应用（亲测支持系统相册、备忘录、QQ发送聊天等） DragAndDropKit本组件目前支持Drop 接收 UIImage、本地视频（路径下的视频）、网络图片、网络视频、文本等。目前也是支持UIView及其类UIImageView、UILabel等、以及TableView、CollectionView快速拖动其子Cell。

### Usage

支持类型参数，所有UIView类别、TableView、CollectionView、均可赋值supportSources，用来声明drop接收时候能支持的类型数据，默认全部支持(Image、Video、Text)三种。（注：并不是系统api只支持这三种，是这三种比较广泛，第一期先支持此三种数据的接收）

```

c.drop.supportSources = [.rawImage,.rawVideo,.text]

```

UIView Drop, didReceivedDropSource闭包必须实现用以接收到source后你对source的处理，其他可选。

```

self.view.drop.supportSources = [.rawImage]
            self.view.drop.enabled().didReceivedDropSource { [weak self] dropSources in
                for (_, item) in dropSources.enumerated() {
                    if let imageSource = item as? ImageDropSource {
                        self?.imageView.image = imageSource.image
                        self?.imageView.layer.borderWidth = 0.0
                        break
                    }
                }
            }.didEnterDropSession { interaction, session in
                if session.localDragSession == nil {
                    JFPopupView.popup.toast {
                        [.hit("请移入右上角图片中替换"),
                         .withoutAnimation(true),
                         .position(.top),
                         .autoDismissDuration(.seconds(value: 3)),
                         .bgColor(UIColor.jf.rgb(0x000000, alpha: 0.3))
                        ]
                    }
                }
            }.didUpdateDropSource { [weak self] interaction, session in
                guard let self = self else {
                    return UIDropProposal(operation: UIDropOperation.cancel)
                }
                let dropLocation = session.location(in: self.view)
                
                let operation: UIDropOperation
                
                if self.imageView.frame.contains(dropLocation) {
                    operation = session.localDragSession == nil ? .copy : .move
                    self.checkIsMatch(match: true)
                } else {
                    operation = .cancel
                    self.checkIsMatch(match: false)
                }
                self.updateLayers(forDropLocation: dropLocation)
                
                return UIDropProposal(operation: operation)
            }.didEndDropSession { [weak self] interaction, session in
                guard let self = self else { return }
                let dropLocation = session.location(in: self.view)
                self.updateLayers(forDropLocation: dropLocation)
                self.checkIsMatch(match: false)
            }.didExitDropSession { [weak self] interaction, session in
                guard let self = self else { return }
                self.imageView.layer.borderWidth = 0.0
            }
        }

```

UICollectionView类似,也是collectionViewDidReceivedDropSource必须处理，其他生命周期闭包，可选。

```

c.drop.supportSources = [.rawImage,.rawVideo,.text]
            c.drop.enabled().collectionViewDidReceivedDropSource { [weak self] collectionView, coordinator, dropSources in
                let destinationIndexPath: IndexPath
                
                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    let item = collectionView.numberOfItems(inSection: 0)
                    destinationIndexPath = IndexPath(item: item, section: 0)
                }
                var indexPaths = [IndexPath]()
                for (index, item) in dropSources.enumerated() {
                    let indexPath = IndexPath(item: destinationIndexPath.item + index, section: destinationIndexPath.section)
                    self?.dragAndDropVM.addItem(item, at: indexPath.item)
                    indexPaths.append(indexPath)
                }
                self?.collectionView.insertItems(at: indexPaths)
            }

```

UITableView类似,也是tableViewDidReceivedDropSource必须处理，其他生命周期闭包，可选。

```

t.drop.supportSources = [.rawImage,.rawVideo,.text]
            t.drop.enabled().tableViewDidReceivedDropSource { [weak self] tableView, coordinator, dropSources in
                guard let self = self else { return }
                
                let destinationIndexPath: IndexPath
                
                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    let item = tableView.numberOfRows(inSection: 0)
                    destinationIndexPath = IndexPath(row: item, section: 0)
                }
                var indexPaths = [IndexPath]()
                for (index, item) in dropSources.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.item + index, section: destinationIndexPath.section)
                    self.models.insert(item, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
                tableView.insertRows(at: indexPaths, with: .bottom)
            }

```

效果：

![](http://image.jerryfans.com/drop_view.gif)

拖拽本应用的data到其他实现了Drop协议的应用（亲测支持系统相册、备忘录、网页里面的文本选中范围后直接拖拽等） DragAndDropKit本组件目前支持拖拽UIImage、本地视频（路径下的视频）、网络图片、网络视频、文本等。目前支持UIView及其类UIImageView、UILabel等、以及TableView、CollectionView快速拖动其子Cell。


## Author

fanjiaorng919, fanjiarong_haohao@163.com

## License

DragAndDropKit is available under the MIT license. See the LICENSE file for more info.
