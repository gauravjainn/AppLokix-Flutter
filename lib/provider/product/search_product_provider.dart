import 'dart:async';

import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class SearchProductProvider extends PsProvider {
  SearchProductProvider(
      {@required ProductRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

       _productList =
          PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

      print('**** SearchProductProvider ${resource.data.length}');
      _tempProductList = resource;

      for (int i = 0; i < _tempProductList.data.length; i++) {
        if ( PsConfig.isShowAdMobInsideList && (i + 1) % PsConfig.afterItemCountAdmobOnce == 0) {
          _productList.data.add(_tempProductList.data[i]);
          _productList.data.add(
              Product(id: PsConst.ADMOB_FLAG + _tempProductList.data[i].id));
        } else {
          _productList.data.add(_tempProductList.data[i]);
        }
      }
      _productList.data = Product().checkDuplicate(_productList.data);

       if (_productList.data == null || _productList.data.isEmpty || _productList.status != PsStatus.SUCCESS) {
        _productList.status = resource.status;
        _productList.message = resource.message;
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
  ProductRepository _repo;
  PsValueHolder psValueHolder;
  PsResource<List<Product>> _tempProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
 PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  PsResource<List<Product>> get tempProductList => _tempProductList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;

  dynamic daoSubscription;

  ProductParameterHolder productParameterHolder;

  bool isSwitchedFeaturedProduct = false;
  bool isSwitchedDiscountPrice = false;

  String selectedCategoryName = '';
  String selectedSubCategoryName = '';
  String selectedItemTypeName = '';
  String selectedItemConditionName = '';
  String selectedItemPriceTypeName = '';
  String selectedItemDealOptionName = '';

  String categoryId = '';
  String subCategoryId = '';
  String itemTypeId = '';
  String itemConditionId = '';
  String itemPriceTypeId = '';
  String itemDealOptionId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  String _itemLocationId;
  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Search Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByKey(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    if (PsConfig.noFilterWithLocationOnMap) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationId;
        productParameterHolder.itemLocationId = '';
      } else {
        if (_itemLocationId != null && _itemLocationId != '') {
          productParameterHolder.itemLocationId = _itemLocationId;
        }
      }
    }

    daoSubscription = await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);
  }

  Future<dynamic> nextProductListByKey(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      if (PsConfig.noFilterWithLocationOnMap) {
        if (productParameterHolder.lat != '' &&
            productParameterHolder.lng != '' &&
            productParameterHolder.lat != null &&
            productParameterHolder.lng != null) {
          _itemLocationId = productParameterHolder.itemLocationId;
          productParameterHolder.itemLocationId = '';
        } else {
          if (_itemLocationId != null && _itemLocationId != '') {
            productParameterHolder.itemLocationId = _itemLocationId;
          }
        }
      }

      await _repo.getNextPageProductList(
          productListStream,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }

  Future<void> resetLatestProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (PsConfig.noFilterWithLocationOnMap) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationId;
        productParameterHolder.itemLocationId = '';
      } else {
        if (_itemLocationId != null && _itemLocationId != '') {
          productParameterHolder.itemLocationId = _itemLocationId;
        }
      }
    }

    updateOffset(0);

    isLoading = true;
    daoSubscription = await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);
  }
}
