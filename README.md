# CardView
a  beautiful cardView and easy to use.

It can be dragged to remove, so you can use it to delete pics or show app's new features.

[中文说明](http://blog.csdn.net/ch_quan/article/details/79200800)

You can use it just like use a TableView, apply to  CardViewDelegate and CardViewDataSource.

You can use delegate to listen to Click and Remove event.

use dataSorce to return number and cardItem.


![CardView](https://github.com/chquanquan/CardView/blob/master/cardView.gif?raw=true)


eg:

```
extension ViewController:CardViewDelegate {

func didClick(cardView: CardView, with index: Int) {
print("click index:\(index)")
}

func remove(cardView: CardView, item: CardItem, with index: Int) {
print("remove:\(index)")
if index == count - 1 {
cardView.reloadData()
}
}

}
```

```
extension ViewController:CardViewDataSource {

func numberOfItems(in cardView: CardView) -> Int {
return count
}

func cardView(_ cardView:CardView, cellForItemAt Index:Int) ->CardItem {

// first item at top.
var item: ImageCardItem!
if let image =UIImage(named:"img_0" +"\(Index)") {
item = ImageCardItem(image: image)
}

if Index == count - 1 {
addStartButton(item: item)
// decide to pan
item.isPan = false.
}
return item
}
}
```


By the way, if you want to load local images, use ImageCardItem,if you want to load network Images, just implement your LoadImage func in imageView.
If you want to a custom cardItem, please add your subviews to cardItem's contentView. or inherit cardItem

This CardView also can be removed cardItem by code for four direction.

This demo clearly shows about how to use a CardView......^_^


