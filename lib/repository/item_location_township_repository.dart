import 'dart:async';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/item_loacation_township_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class ItemLocationTownshipRepository extends PsRepository {
  ItemLocationTownshipRepository(
      {@required PsApiService psApiService,
      @required ItemLocationTownshipDao itemLocationTownshipDao}) {
    _psApiService = psApiService;
    _itemLocationTownshipDao = itemLocationTownshipDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemLocationTownshipDao _itemLocationTownshipDao;

  Future<dynamic> insert(ItemLocationTownship itemLocationTownship) async {
    return _itemLocationTownshipDao.insert(primaryKey, itemLocationTownship);
  }

  Future<dynamic> update(ItemLocationTownship itemLocationTownship) async {
    return _itemLocationTownshipDao.update(itemLocationTownship);
  }

  Future<dynamic> delete(ItemLocationTownship itemLocationTownship) async {
    return _itemLocationTownshipDao.delete(itemLocationTownship);
  }

  Future<dynamic> getAllItemLocationTownshipList(
      StreamController<PsResource<List<ItemLocationTownship>>>
          itemLocationListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('city_id', cityId));

    itemLocationListStream.sink.add(
        await _itemLocationTownshipDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocationTownship>> _resource =
          await _psApiService.getItemLocationTownshipList(
              jsonMap, loginUserId, limit, offset, cityId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationTownshipDao.deleteWithFinder(finder);
        await _itemLocationTownshipDao.insertAll(primaryKey, _resource.data);
        itemLocationListStream.sink
            .add(await _itemLocationTownshipDao.getAll());
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemLocationTownshipDao.deleteWithFinder(finder);
        }
      }
      itemLocationListStream.sink.add(await _itemLocationTownshipDao.getAll(
          finder: finder,
          status: _resource.status,
          message: _resource.message));
    }
  }

  Future<dynamic> getNextPageItemLocationTownshipList(
      StreamController<PsResource<List<ItemLocationTownship>>>
          itemLocationListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      String cityId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('city_id', cityId));

    itemLocationListStream.sink.add(
        await _itemLocationTownshipDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocationTownship>> _resource =
          await _psApiService.getItemLocationTownshipList(
              jsonMap, loginUserId, limit, offset, cityId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationTownshipDao.insertAll(primaryKey, _resource.data);
      }
      itemLocationListStream.sink
          .add(await _itemLocationTownshipDao.getAll(finder: finder));
    }
  }
}
