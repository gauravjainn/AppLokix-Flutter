import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class DeleteItemImageHolder extends PsHolder<DeleteItemImageHolder> {
  DeleteItemImageHolder({
    @required this.imageId,
  });

  final String imageId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['img_id'] = imageId;
    return map;
  }

  @override
  DeleteItemImageHolder fromMap(dynamic dynamicData) {
    return DeleteItemImageHolder(
      imageId: dynamicData['img_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (imageId != '') {
      key += imageId;
    }

    return key;
  }
}
