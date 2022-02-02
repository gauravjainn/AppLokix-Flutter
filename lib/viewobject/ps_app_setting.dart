import 'package:quiver/core.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_object.dart';

class AppSetting extends PsObject<AppSetting> {
  AppSetting({this.latitude, this.longitude, this.isSubLocation});
  String latitude;
  String longitude;
  String isSubLocation;

  @override
  bool operator ==(dynamic other) =>
      other is AppSetting && latitude == other.latitude;

  @override
  int get hashCode => hash2(latitude.hashCode, latitude.hashCode);

  @override
  String getPrimaryKey() {
    return latitude;
  }

  @override
  AppSetting fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AppSetting(
          latitude: dynamicData['lat'],
          longitude: dynamicData['lng'],
          isSubLocation: dynamicData['is_sub_location']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['lat'] = object.latitude;
      data['lng'] = object.longitude;
      data['is_sub_location'] = object.isSubLocation;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AppSetting> fromMapList(List<dynamic> dynamicDataList) {
    final List<AppSetting> appSettingList = <AppSetting>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          appSettingList.add(fromMap(json));
        }
      }
    }
    return appSettingList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AppSetting> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AppSetting data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
