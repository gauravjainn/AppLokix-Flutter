import 'dart:async';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/user_unread_message_dao.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/user_unread_message.dart';
import 'Common/ps_repository.dart';

class UserUnreadMessageRepository extends PsRepository {
  UserUnreadMessageRepository(
      {@required PsApiService psApiService,
      @required UserUnreadMessageDao userUnreadMessageDao}) {
    _psApiService = psApiService;
    _userUnreadMessageDao = userUnreadMessageDao;
  }

  String primaryKey = 'id';
  String mapKey = 'map_key';
  PsApiService _psApiService;
  UserUnreadMessageDao _userUnreadMessageDao;

  void sinkUserUnreadMessageCountStream(
      StreamController<PsResource<UserUnreadMessage>>
          userUnreadMessageCountStream,
      PsResource<UserUnreadMessage> data) {
    if (data != null) {
      userUnreadMessageCountStream.sink.add(data);
    }
  }

  Future<dynamic> insert(UserUnreadMessage userUnreadMessage) async {
    return _userUnreadMessageDao.insert(primaryKey, userUnreadMessage);
  }

  Future<dynamic> update(UserUnreadMessage userUnreadMessage) async {
    return _userUnreadMessageDao.update(userUnreadMessage);
  }

  Future<dynamic> delete(UserUnreadMessage userUnreadMessage) async {
    return _userUnreadMessageDao.delete(userUnreadMessage);
  }

  Future<dynamic> postUserUnreadMessageCount(
      StreamController<PsResource<UserUnreadMessage>>
          userUnreadMessageCountStream,
      UserUnreadMessageParameterHolder holder,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();

    sinkUserUnreadMessageCountStream(
        userUnreadMessageCountStream,
        await _userUnreadMessageDao.getOne(
          status: status,
        ));
    final PsResource<UserUnreadMessage> _resource =
        await _psApiService.postUserUnreadMessageCount(holder.toMap());
    if(_resource != null && _resource.data != null && _resource.data.id == null){
      _resource.data.id = '1';
    }
    if (_resource.status == PsStatus.SUCCESS) {
      await _userUnreadMessageDao.deleteAll();
      await _userUnreadMessageDao.insert(primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await _userUnreadMessageDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
      }
    }

    final dynamic subscription = _userUnreadMessageDao.getOneWithSubscription(
        status: PsStatus.SUCCESS,
        onDataUpdated: (UserUnreadMessage message) {
          if (status != null && status != PsStatus.NOACTION) {
            print(status);
            userUnreadMessageCountStream.sink
                .add(PsResource<UserUnreadMessage>(status, '', message));
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> postDeleteUserUnreadMessageCount(
    StreamController<PsResource<UserUnreadMessage>>
    userUnreadMessageCountStream,
    bool isConnectedToInternet,
    PsStatus status,
    {bool isLoadFromServer = true}) async {
     
      await _userUnreadMessageDao.deleteAll();

      final dynamic subscription = _userUnreadMessageDao.getOneWithSubscription(
          status: PsStatus.SUCCESS,
          onDataUpdated: (UserUnreadMessage message) {
            if (status != null && status != PsStatus.NOACTION) {
              print(status);
              userUnreadMessageCountStream.sink
                  .add(PsResource<UserUnreadMessage>(status, '', message));
            } else {
              print('No Action');
            }
          });

      return subscription;
    }
}


