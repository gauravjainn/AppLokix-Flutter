import 'dart:async';
import 'dart:io';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';

class GalleryProvider extends PsProvider {
  GalleryProvider({@required GalleryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Gallery Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    galleryListStream =
        StreamController<PsResource<List<DefaultPhoto>>>.broadcast();
    subscription = galleryListStream.stream
        .listen((PsResource<List<DefaultPhoto>> resource) {
      updateOffset(resource.data.length);

      _galleryList = resource;
      if (_galleryList != null) {
        selectedImageList = _galleryList.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  GalleryRepository _repo;
  List<DefaultPhoto> selectedImageList = <DefaultPhoto>[];

  PsResource<List<DefaultPhoto>> _galleryList =
      PsResource<List<DefaultPhoto>>(PsStatus.NOACTION, '', <DefaultPhoto>[]);

  PsResource<List<DefaultPhoto>> get galleryList => _galleryList;
  StreamSubscription<PsResource<List<DefaultPhoto>>> subscription;
  StreamController<PsResource<List<DefaultPhoto>>> galleryListStream;

  PsResource<DefaultPhoto> _defaultPhoto =
      PsResource<DefaultPhoto>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Gallery Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadImageList(
    String parentImgId,
    String imageType,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllImageList(galleryListStream, isConnectedToInternet,
        parentImgId, imageType, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> postItemImageUpload(
    String itemId,
    String imgId,
    String ordering,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _defaultPhoto = await _repo.postItemImageUpload(itemId, imgId, ordering,
        imageFile, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _defaultPhoto;
  }

  Future<dynamic> deleItemImage(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.deleItemImage(
        jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChatImageUpload(
    String senderId,
    String sellerUserId,
    String buyerUserId,
    String itemId,
    String type,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _defaultPhoto = await _repo.postChatImageUpload(
        senderId, sellerUserId, buyerUserId, itemId, type, imageFile);

    return _defaultPhoto;
  }

  Future<void> resetGalleryList(
    String parentImgId,
    String imageType,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllImageList(galleryListStream, isConnectedToInternet,
        parentImgId, imageType, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
