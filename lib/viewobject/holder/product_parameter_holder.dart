import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart';

class ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
  }

  String searchTerm;
  String catId;
  String subCatId;
  String itemTypeId;
  String itemPriceTypeId;
  String itemCurrencyId;
  String itemLocationId;
  String itemLocationTownshipId;
  String dealOptionId;
  String conditionOfItemId;
  String maxPrice;
  String minPrice;
  String brand;
  String lat;
  String lng;
  String mile;
  String orderBy;
  String orderType;
  String addedUserId;
  String isPaid;
  String status;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
            orderType == '' &&
            minPrice == '' &&
            maxPrice == '' &&
            itemTypeId == '' &&
            conditionOfItemId == '' &&
            itemPriceTypeId == '' &&
            dealOptionId == '' &&
            searchTerm == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(catId == '' && subCatId == '');
  }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPaidItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.ONLY_PAID_ITEM;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';

    return this;
  }

  ProductParameterHolder getFeaturedParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['deal_option_id'] = dealOptionId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['brand'] = brand;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = mile;
    map['added_user_id'] = addedUserId;
    map['is_paid'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    conditionOfItemId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm + ':';
    }
    if (catId != '') {
      result += catId + ':';
    }
    if (subCatId != '') {
      result += subCatId + ':';
    }
    if (itemTypeId != '') {
      result += itemTypeId + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId + ':';
    }
    if (itemLocationTownshipId != '') {
      result += itemLocationTownshipId + ':';
    }
    if (dealOptionId != '') {
      result += dealOptionId + ':';
    }
    if (conditionOfItemId != '') {
      result += conditionOfItemId + ':';
    }
    if (maxPrice != '') {
      result += maxPrice + ':';
    }
    if (minPrice != '') {
      result += minPrice + ':';
    }
    if (brand != '') {
      result += brand + ':';
    }
    if (lat != '') {
      result += lat + ':';
    }
    if (lng != '') {
      result += lng + ':';
    }
    if (mile != '') {
      result += mile + ':';
    }
    if (addedUserId != '') {
      result += addedUserId + ':';
    }
    if (status != '') {
      result += status + ':';
    }
    if (isPaid != '') {
      result += isPaid + ':';
    }
    if (orderBy != '') {
      result += orderBy + ':';
    }
    if (orderType != '') {
      result += orderType;
    }

    return result;
  }
}
