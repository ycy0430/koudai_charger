/// 使用 File api
import 'dart:io';

/// 使用 Uint8List 数据类型
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// 使用 DefaultCacheManager 类（可能无法自动引入，需要手动引入）

/// 授权管理
import 'package:permission_handler/permission_handler.dart';

/// 图片缓存管理
/// 保存文件或图片到本地

class AppUtil {
  /// 保存图片到相册
  ///
  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static Future<void> saveImage(
    String imageUrl, {
    bool isAsset: false,
  }) async {
    try {
      if (imageUrl == null) throw '保存失败，图片不存在！';

      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      /// 保存的图片数据
      Uint8List imageBytes;

      if (isAsset == true) {
        /// 保存资源图片
        ByteData bytes = await rootBundle.load(imageUrl);
        imageBytes = bytes.buffer.asUint8List();
      } else {
        /// 保存网络图片
        CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl);
        DefaultCacheManager manager =
            image.cacheManager ?? DefaultCacheManager();
        Map<String, String> headers = image.httpHeaders;
        File file = await manager.getSingleFile(
          image.imageUrl,
          headers: headers,
        );
        imageBytes = await file.readAsBytes();
      }

      /// 保存图片
      final result = await ImageGallerySaver.saveImage(imageBytes);
      if (result == null || result == '') throw '图片保存失败';

      print("保存成功$result");
      Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // 消息框弹出的位置
          // timeInSecForIos: 1, // 消息框持续的时间（目前的版本只有ios有效）
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "保存失败",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // 消息框弹出的位置
          // timeInSecForIos: 1, // 消息框持续的时间（目前的版本只有ios有效）
          backgroundColor: Colors.white,
          textColor: Colors.white54,
          fontSize: 16.0);
    }
  }
}
