import 'package:flutter/material.dart';
import 'package:koudai_charger/common/Photo_Save.dart';
import 'package:photo_view/photo_view.dart';

//图片详情窗口
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class PhotoViewSimpleScreen extends StatelessWidget {
  const PhotoViewSimpleScreen({
    this.imageProvider, //图片
    this.loadingChild, //加载时的widget
    this.backgroundDecoration, //背景修饰
    this.minScale, //最大缩放倍数
    this.maxScale, //最小缩放倍数
    this.heroTag,
    this.imgurl, //hero动画tagid
  });
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;
  final String imgurl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: InkWell(
                child: PhotoView(
                  imageProvider: imageProvider,
                  backgroundDecoration: backgroundDecoration,
                  minScale: minScale,
                  maxScale: maxScale,
                  heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                  enableRotation: true,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
                onLongPress: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      builder: (BuildContext context) {
                        return Container(
                          height: 60,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              AppUtil.saveImage(imgurl);
                            },
                            child: Text(
                              "保存本地",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
            Positioned(
                //右上角关闭按钮
                right: 10,
                top: MediaQuery.of(context).padding.top,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.file_download,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        AppUtil.saveImage(imgurl);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print(imageProvider);
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
