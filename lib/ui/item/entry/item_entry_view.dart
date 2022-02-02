import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/entry/item_entry_provider.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/condition_of_item.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutterbuyandsell/viewobject/holder/delete_item_image_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/google_map_pin_call_back_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_currency.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:flutterbuyandsell/viewobject/item_price_type.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key key, this.flag, this.item, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final String flag;
  final Product item;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository repo1;
  GalleryRepository galleryRepository;
  ItemEntryProvider _itemEntryProvider;
  GalleryProvider galleryProvider;
  PsValueHolder valueHolder;
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController googleMapController;

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationTownshipController =
      TextEditingController();

  LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
  // New Images From Image Picker
  List<Asset> images = <Asset>[];
  Asset firstSelectedImageAsset;
  Asset secondSelectedImageAsset;
  Asset thirdSelectedImageAsset;
  Asset fouthSelectedImageAsset;
  Asset fifthSelectedImageAsset;
  String firstCameraImagePath;
  String secondCameraImagePath;
  String thirdCameraImagePath;
  String fouthCameraImagePath;
  String fifthCameraImagePath;

  Asset defaultAssetImage;

  // New Images Checking from Image Picker
  bool isSelectedFirstImagePath = false;
  bool isSelectedSecondImagePath = false;
  bool isSelectedThirdImagePath = false;
  bool isSelectedFouthImagePath = false;
  bool isSelectedFifthImagePath = false;

  String isShopCheckbox = '1';

  dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }

  // ProgressDialog progressDialog;

  // File file;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    Future<dynamic> uploadImage(String itemId) async {
      bool _isFirstDone = isSelectedFirstImagePath;
      bool _isSecondDone = isSelectedSecondImagePath;
      bool _isThirdDone = isSelectedThirdImagePath;
      bool _isFouthDone = isSelectedFouthImagePath;
      bool _isFifthDone = isSelectedFifthImagePath;

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFirstImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image1_uploading'));
        }
      }

      if (isSelectedFirstImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.firstImageId,
                '1',
                firstSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        firstCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        firstSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedFirstImagePath = false;
          _isFirstDone = isSelectedFirstImagePath;
          print('1 image uploaded');
          // if (isSelectedSecondImagePath ||
          //     isSelectedThirdImagePath ||
          //     isSelectedFouthImagePath ||
          //     isSelectedFifthImagePath) {
          //   //secondCameraImagePath = "3232323";
          //   // await uploadImage(itemId + "32322323");
          //   // await uploadImage(itemId);
          // }
        }
      }
      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedSecondImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image2_uploading'));
        }
      }
      if (isSelectedSecondImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.secondImageId,
                '2',
                secondSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        secondCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        secondSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedSecondImagePath = false;
          _isSecondDone = isSelectedSecondImagePath;
          print('2 image uploaded');
          // if (isSelectedThirdImagePath ||
          //     isSelectedFouthImagePath ||
          //     isSelectedFifthImagePath) {
          //   // await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedThirdImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image3_uploading'));
        }
      }

      if (isSelectedThirdImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.thirdImageId,
                '3',
                thirdSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        thirdCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        thirdSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedThirdImagePath = false;
          _isThirdDone = isSelectedThirdImagePath;
          print('3 image uploaded');
          // if (isSelectedFouthImagePath || isSelectedFifthImagePath) {
          //   // await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFouthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image4_uploading'));
        }
      }

      if (isSelectedFouthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fourthImageId,
                '4',
                fouthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        fouthCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        fouthSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedFouthImagePath = false;
          _isFouthDone = isSelectedFouthImagePath;
          print('4 image uploaded');
          // if (isSelectedFifthImagePath) {
          //   // await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFifthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image5_uploading'));
        }
      }

      if (isSelectedFifthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fiveImageId,
                '5',
                fifthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        fifthCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        fifthSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          print('5 image uploaded');
          isSelectedFifthImagePath = false;
          _isFifthDone = isSelectedFifthImagePath;
        }
      }

      PsProgressDialog.dismissDialog();

      if (!(_isFirstDone ||
          _isSecondDone ||
          _isThirdDone ||
          _isFouthDone ||
          _isFifthDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            });
      }

      return;
    }

    dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == 0 && imagePath.isNotEmpty) {
            firstCameraImagePath = imagePath;
            isSelectedFirstImagePath = true;
          }
          if (index == 1 && imagePath.isNotEmpty) {
            secondCameraImagePath = imagePath;
            isSelectedSecondImagePath = true;
          }
          if (index == 2 && imagePath.isNotEmpty) {
            thirdCameraImagePath = imagePath;
            isSelectedThirdImagePath = true;
          }
          if (index == 3 && imagePath.isNotEmpty) {
            fouthCameraImagePath = imagePath;
            isSelectedFouthImagePath = true;
          }
          if (index == 4 && imagePath.isNotEmpty) {
            fifthCameraImagePath = imagePath;
            isSelectedFifthImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic updateImages(List<Asset> resultList, int index) {
      if (index == -1) {
        firstSelectedImageAsset = defaultAssetImage;
        secondSelectedImageAsset = defaultAssetImage;
        thirdSelectedImageAsset = defaultAssetImage;
        fouthSelectedImageAsset = defaultAssetImage;
        fifthSelectedImageAsset = defaultAssetImage;
      }
      setState(() {
        images = resultList;

        if (resultList.isEmpty) {
          firstSelectedImageAsset = defaultAssetImage;
          isSelectedFirstImagePath = false;
          secondSelectedImageAsset = defaultAssetImage;
          isSelectedSecondImagePath = false;
          thirdSelectedImageAsset = defaultAssetImage;
          isSelectedThirdImagePath = false;
          fouthSelectedImageAsset = defaultAssetImage;
          isSelectedFouthImagePath = false;
          fifthSelectedImageAsset = defaultAssetImage;
          isSelectedFifthImagePath = false;
        }

        //for single select image
        if (index == 0 && resultList.isNotEmpty) {
          firstSelectedImageAsset = resultList[0];
          isSelectedFirstImagePath = true;
        }
        if (index == 1 && resultList.isNotEmpty) {
          secondSelectedImageAsset = resultList[0];
          isSelectedSecondImagePath = true;
        }
        if (index == 2 && resultList.isNotEmpty) {
          thirdSelectedImageAsset = resultList[0];
          isSelectedThirdImagePath = true;
        }
        if (index == 3 && resultList.isNotEmpty) {
          fouthSelectedImageAsset = resultList[0];
          isSelectedFouthImagePath = true;
        }
        if (index == 4 && resultList.isNotEmpty) {
          fifthSelectedImageAsset = resultList[0];
          isSelectedFifthImagePath = true;
        }
        //end single select image

        //for multi select
        if (index == -1 && resultList.length == 1) {
          firstSelectedImageAsset = resultList[0];
          isSelectedFirstImagePath = true;
        }
        if (index == -1 && resultList.length == 2) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
        }
        if (index == -1 && resultList.length == 3) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
        }
        if (index == -1 && resultList.length == 4) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          fouthSelectedImageAsset = resultList[3];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
          isSelectedFouthImagePath = true;
        }
        if (index == -1 && resultList.length == 5) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          fouthSelectedImageAsset = resultList[3];
          fifthSelectedImageAsset = resultList[4];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
          isSelectedFouthImagePath = true;
          isSelectedFifthImagePath = true;
        }
        //end multi select

        // if (index >= 0 && galleryProvider.selectedImageList.length > index) {
        //   galleryProvider.selectedImageList.removeAt(index);
        // }
      });
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    widget.animationController.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider.item = widget.item;

                  if (valueHolder.isSubLocation == PsConst.ONE) {
                    latlng = LatLng(
                        double.parse(_itemEntryProvider
                            .psValueHolder.locationTownshipLat),
                        double.parse(_itemEntryProvider
                            .psValueHolder.locationTownshipLng));
                    if (_itemEntryProvider.itemLocationTownshipId != null ||
                        _itemEntryProvider.itemLocationTownshipId != '') {
                      _itemEntryProvider.itemLocationTownshipId =
                          _itemEntryProvider.psValueHolder.locationTownshipId;
                    }
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider.psValueHolder.locationTownshipLat;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider.psValueHolder.locationTownshipLng;
                  } else {
                    latlng = LatLng(
                        double.parse(
                            _itemEntryProvider.psValueHolder.locationLat),
                        double.parse(
                            _itemEntryProvider.psValueHolder.locationLng));
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider.psValueHolder.locationLat;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider.psValueHolder.locationLng;
                  }
                  if (_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider.itemLocationId != '') {
                    _itemEntryProvider.itemLocationId =
                        _itemEntryProvider.psValueHolder.locationId;
                  }
                  _itemEntryProvider.itemCurrencyId =
                      _itemEntryProvider.psValueHolder.defaultCurrencyId;
                  priceController.text =
                      _itemEntryProvider.psValueHolder.defaultCurrency;
                  _itemEntryProvider.getItemFromDB(widget.item.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider.loadImageList(
                        widget.item.defaultPhoto.imgParentId,
                        PsConst.ITEM_TYPE);

                    // firstImageId = galleryProvider.galleryList.data[0].imgId;
                    // secondImageId = galleryProvider.galleryList.data[1].imgId;
                    // thirdImageId = galleryProvider.galleryList.data[2].imgId;
                    // fourthImageId = galleryProvider.galleryList.data[3].imgId;
                    // fiveImageId = galleryProvider.galleryList.data[4].imgId;

                    // Utils.psPrint(firstImageId);
                    // Utils.psPrint(secondImageId);
                    // Utils.psPrint(thirdImageId);
                    // Utils.psPrint(fourthImageId);
                    // Utils.psPrint(fiveImageId);
                  }
                  return galleryProvider;
                }),
          ],
          child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                child: Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: PsColors.categoryBackgroundColor,
                        padding: const EdgeInsets.all(PsDimens.space16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                Utils.getString(
                                    context, 'item_entry__listing_today'),
                                style: Theme.of(context).textTheme.subtitle1.copyWith(color:Utils.isLightMode(context)? PsColors.mainColor:Colors.white, fontWeight: FontWeight.w600)),
                                const SizedBox(height: PsDimens.space4,),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      Utils.getString(context,
                                          'item_entry__choose_photo_showcase'),
                                      style: Theme.of(context).textTheme.button.copyWith(color:Utils.isLightMode(context)? PsColors.mainColor:Colors.white, fontWeight:FontWeight.w400),)
                                ),
                                // Text(' *',
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .bodyText2
                                //         .copyWith(color: PsColors.mainColor))
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget child) {
                        if (provider != null &&
                            provider.galleryList.data.isNotEmpty) {
                          for (int imageId = 0;
                              imageId < provider.galleryList.data.length;
                              imageId++) {
                            if (imageId == 0 &&
                                provider.galleryList.data[imageId] != null &&
                                provider.galleryList.data[imageId].imgId !=
                                    null) {
                              _itemEntryProvider.firstImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 1 &&
                                provider.galleryList.data[imageId] != null &&
                                provider.galleryList.data[imageId].imgId !=
                                    null) {
                              _itemEntryProvider.secondImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 2 &&
                                provider.galleryList.data[imageId] != null &&
                                provider.galleryList.data[imageId].imgId !=
                                    null) {
                              _itemEntryProvider.thirdImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 3 &&
                                provider.galleryList.data[imageId] != null &&
                                provider.galleryList.data[imageId].imgId !=
                                    null) {
                              _itemEntryProvider.fourthImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 4 &&
                                provider.galleryList.data[imageId] != null &&
                                provider.galleryList.data[imageId].imgId !=
                                    null) {
                              _itemEntryProvider.fiveImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                          }
                        }

                        return ImageUploadHorizontalList(
                          flag: widget.flag,
                          images: images,
                          selectedImageList: galleryProvider.selectedImageList,
                          updateImages: updateImages,
                          updateImagesFromCustomCamera:
                              updateImagesFromCustomCamera,
                          firstImagePath: firstSelectedImageAsset,
                          secondImagePath: secondSelectedImageAsset,
                          thirdImagePath: thirdSelectedImageAsset,
                          fouthImagePath: fouthSelectedImageAsset,
                          fifthImagePath: fifthSelectedImageAsset,
                          firstCameraImagePath: firstCameraImagePath,
                          secondCameraImagePath: secondCameraImagePath,
                          thirdCameraImagePath: thirdCameraImagePath,
                          fouthCameraImagePath: fouthCameraImagePath,
                          fifthCameraImagePath: fifthCameraImagePath,
                        );
                      }),

                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                              Widget child) {
                        if (provider != null &&
                            provider.item != null &&
                            provider.item.id != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text = provider.item.title;
                            userInputBrand.text = provider.item.brand;
                            userInputHighLightInformation.text =
                                provider.item.highlightInformation;
                            userInputDescription.text =
                                provider.item.description;
                            userInputDealOptionText.text =
                                provider.item.dealOptionRemark;

                            if (valueHolder.isSubLocation == PsConst.ONE) {
                              userInputLattitude.text =
                                  provider.item.itemLocationTownship.lat;
                              userInputLongitude.text =
                                  provider.item.itemLocationTownship.lng;
                              provider.itemLocationTownshipId =
                                  provider.item.itemLocationTownship.id;
                              locationTownshipController.text = provider
                                  .item.itemLocationTownship.townshipName;
                            } else {
                              userInputLattitude.text = provider.item.lat;
                              userInputLongitude.text = provider.item.lng;
                            }
                            provider.itemLocationId =
                                provider.item.itemLocation.id;
                            locationController.text =
                                provider.item.itemLocation.name;
                            userInputAddress.text = provider.item.address;
                            userInputPrice.text = provider.item.price;
                            categoryController.text =
                                provider.item.category.catName;
                            subCategoryController.text =
                                provider.item.subCategory.name;
                            typeController.text = provider.item.itemType.name;
                            itemConditionController.text =
                                provider.item.conditionOfItem.name;
                            priceTypeController.text =
                                provider.item.itemPriceType.name;
                            priceController.text =
                                provider.item.itemCurrency.currencySymbol;
                            dealOptionController.text =
                                provider.item.dealOption.name;
                            provider.categoryId = provider.item.category.catId;
                            provider.subCategoryId =
                                provider.item.subCategory.id;
                            provider.itemTypeId = provider.item.itemType.id;
                            provider.itemConditionId =
                                provider.item.conditionOfItem.id;
                            provider.itemCurrencyId =
                                provider.item.itemCurrency.id;
                            provider.itemDealOptionId =
                                provider.item.dealOption.id;
                            provider.itemPriceTypeId =
                                provider.item.itemPriceType.id;
                            bindDataFirstTime = false;

                            if (provider.item.businessMode == '1') {
                              Utils.psPrint('Check On is shop');
                              provider.isCheckBoxSelect = true;
                              _BusinessModeCheckbox();
                            } else {
                              provider.isCheckBoxSelect = false;
                              Utils.psPrint('Check Off is shop');
                              //  updateCheckBox(context, provider);
                              _BusinessModeCheckbox();
                            }
                          }
                        }
                        return AllControllerTextWidget(
                          userInputListingTitle: userInputListingTitle,
                          categoryController: categoryController,
                          subCategoryController: subCategoryController,
                          typeController: typeController,
                          itemConditionController: itemConditionController,
                          userInputBrand: userInputBrand,
                          priceTypeController: priceTypeController,
                          priceController: priceController,
                          userInputHighLightInformation:
                              userInputHighLightInformation,
                          userInputDescription: userInputDescription,
                          dealOptionController: dealOptionController,
                          userInputDealOptionText: userInputDealOptionText,
                          locationController: locationController,
                          locationTownshipController:
                              locationTownshipController,
                          userInputLattitude: userInputLattitude,
                          userInputLongitude: userInputLongitude,
                          userInputAddress: userInputAddress,
                          userInputPrice: userInputPrice,
                          mapController: mapController,
                          zoom: zoom,
                          flag: widget.flag,
                          item: widget.item,
                          provider: provider,
                          galleryProvider: galleryProvider,
                          latlng: latlng,
                          uploadImage: (String itemId) {
                            if (isSelectedFirstImagePath ||
                                isSelectedSecondImagePath ||
                                isSelectedThirdImagePath ||
                                isSelectedFouthImagePath ||
                                isSelectedFifthImagePath) {
                              uploadImage(itemId);
                            }
                          },
                          isSelectedFirstImagePath: isSelectedFirstImagePath,
                          isSelectedSecondImagePath: isSelectedSecondImagePath,
                          isSelectedThirdImagePath: isSelectedThirdImagePath,
                          isSelectedFouthImagePath: isSelectedFouthImagePath,
                          isSelectedFifthImagePath: isSelectedFifthImagePath,
                          updateMapController: updateMapController,
                          googleMapController: googleMapController,
                        );
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return child;
                }),
          )),
    );
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget(
      {Key key,
      this.userInputListingTitle,
      this.categoryController,
      this.subCategoryController,
      this.typeController,
      this.itemConditionController,
      this.userInputBrand,
      this.priceTypeController,
      this.priceController,
      this.userInputHighLightInformation,
      this.userInputDescription,
      this.dealOptionController,
      this.userInputDealOptionText,
      this.locationController,
      this.locationTownshipController,
      this.userInputLattitude,
      this.userInputLongitude,
      this.userInputAddress,
      this.userInputPrice,
      this.mapController,
      this.provider,
      this.galleryProvider,
      this.latlng,
      this.zoom,
      this.flag,
      this.item,
      this.uploadImage,
      this.isSelectedFirstImagePath,
      this.isSelectedSecondImagePath,
      this.isSelectedThirdImagePath,
      this.isSelectedFouthImagePath,
      this.isSelectedFifthImagePath,
      this.googleMapController,
      this.updateMapController,
      this.firstImageId,
      this.secondImageId,
      this.thirdImageId,
      this.fourthImageId,
      this.fiveImageId})
      : super(key: key);

  final TextEditingController userInputListingTitle;
  final TextEditingController categoryController;
  final TextEditingController subCategoryController;
  final TextEditingController typeController;
  final TextEditingController itemConditionController;
  final TextEditingController userInputBrand;
  final TextEditingController priceTypeController;
  final TextEditingController priceController;
  final TextEditingController userInputHighLightInformation;
  final TextEditingController userInputDescription;
  final TextEditingController dealOptionController;
  final TextEditingController userInputDealOptionText;
  final TextEditingController locationController;
  final TextEditingController locationTownshipController;
  final TextEditingController userInputLattitude;
  final TextEditingController userInputLongitude;
  final TextEditingController userInputAddress;
  final TextEditingController userInputPrice;
  final MapController mapController;
  final ItemEntryProvider provider;
  final double zoom;
  final String flag;
  final Product item;
  final LatLng latlng;
  final Function uploadImage;
  final bool isSelectedFirstImagePath;
  final bool isSelectedSecondImagePath;
  final bool isSelectedThirdImagePath;
  final bool isSelectedFouthImagePath;
  final bool isSelectedFifthImagePath;
  final googlemap.GoogleMapController googleMapController;
  final Function updateMapController;

  final String firstImageId;
  final String secondImageId;
  final String thirdImageId;
  final String fourthImageId;
  final String fiveImageId;
  final GalleryProvider galleryProvider;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng _latlng;
  googlemap.CameraPosition _kLake;
  PsValueHolder valueHolder;
  ItemEntryProvider itemEntryProvider;
  googlemap.CameraPosition kGooglePlex;

  @override
  Widget build(BuildContext context) {
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    _latlng ??= widget.latlng;
    kGooglePlex = googlemap.CameraPosition(
      target: googlemap.LatLng(_latlng.latitude, _latlng.longitude),
      zoom: widget.zoom,
    );
    if ((widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController.text ==
                itemEntryProvider.psValueHolder.locactionName) ||
        (widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController.text.isEmpty)) {
      widget.locationController.text =
          itemEntryProvider.psValueHolder.locactionName;
      widget.locationTownshipController.text =
          itemEntryProvider.psValueHolder.locationTownshipName;
    }
    if (itemEntryProvider.item != null && widget.flag == PsConst.EDIT_ITEM) {
      if (valueHolder.isSubLocation == PsConst.ONE) {
        _latlng = LatLng(
            double.parse(itemEntryProvider.item.itemLocationTownship.lat),
            double.parse(itemEntryProvider.item.itemLocationTownship.lng));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(
              double.parse(itemEntryProvider.item.itemLocationTownship.lat),
              double.parse(itemEntryProvider.item.itemLocationTownship.lng)),
          zoom: widget.zoom,
        );
      } else {
        _latlng = LatLng(double.parse(itemEntryProvider.item.lat),
            double.parse(itemEntryProvider.item.lng));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(itemEntryProvider.item.lat),
              double.parse(itemEntryProvider.item.lng)),
          zoom: widget.zoom,
        );
      }
    }

    final Widget _uploadItemWidget = Container(
        // margin: const EdgeInsets.only(
        //     left: PsDimens.space16,
        //     right: PsDimens.space16,
        //     top: PsDimens.space16,
        //     bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
        hasChange: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!widget.isSelectedFirstImagePath &&
                !widget.isSelectedSecondImagePath &&
                !widget.isSelectedThirdImagePath &&
                !widget.isSelectedFouthImagePath &&
                !widget.isSelectedFifthImagePath &&
                widget.galleryProvider.galleryList.data.isEmpty) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_image'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.userInputListingTitle.text == null ||
                widget.userInputListingTitle.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry__need_listing_title'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.categoryController.text == null ||
                widget.categoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_category'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.subCategoryController.text == null ||
                widget.subCategoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_subcategory'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.typeController.text == null ||
                widget.typeController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'item_entry_need_type'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.itemConditionController.text == null ||
                widget.itemConditionController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_item_condition'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.priceController.text == null ||
                widget.priceController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_currency_symbol'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.userInputPrice.text == null ||
                widget.userInputPrice.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_price'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.userInputDescription.text == null ||
                widget.userInputDescription.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_description'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.dealOptionController.text == null ||
                widget.dealOptionController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_deal_option'),
                      onPressed: () {},
                    );
                  });
            } else if (valueHolder.isSubLocation == PsConst.ONE &&
                (widget.locationTownshipController.text == null ||
                    widget.locationTownshipController.text == '')) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_location_township'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.userInputLattitude.text == PsConst.ZERO ||
                widget.userInputLattitude.text == PsConst.ZERO ||
                widget.userInputLattitude.text == PsConst.INVALID_LAT_LNG ||
                widget.userInputLattitude.text == PsConst.INVALID_LAT_LNG) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_pick_location'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));
              }
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  catId: widget.provider.categoryId,
                  subCatId: widget.provider.subCategoryId,
                  itemTypeId: widget.provider.itemTypeId,
                  conditionOfItemId: widget.provider.itemConditionId,
                  itemPriceTypeId: widget.provider.itemPriceTypeId,
                  itemCurrencyId: widget.provider.itemCurrencyId,
                  price: widget.userInputPrice.text,
                  dealOptionId: widget.provider.itemDealOptionId,
                  itemLocationId: widget.provider.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider.itemLocationTownshipId,
                  businessMode: widget.provider.checkOrNotShop,
                  isSoldOut: '', //must be ''
                  title: widget.userInputListingTitle.text,
                  brand: widget.userInputBrand.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation.text,
                  description: widget.userInputDescription.text,
                  dealOptionRemark: widget.userInputDealOptionText.text,
                  latitude: widget.userInputLattitude.text,
                  longitude: widget.userInputLongitude.text,
                  address: widget.userInputAddress.text,
                  id: widget.provider.itemId, //must be '' <<< ID
                  addedUserId: widget.provider.psValueHolder.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider
                    .postItemEntry(itemEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  widget.provider.itemId = itemData.data.id;
                  if (itemData.data != null) {
                    if (widget.isSelectedFirstImagePath ||
                        widget.isSelectedSecondImagePath ||
                        widget.isSelectedThirdImagePath ||
                        widget.isSelectedFouthImagePath ||
                        widget.isSelectedFifthImagePath) {
                      widget.uploadImage(itemData.data.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              } else {
                // edit item

                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  catId: widget.provider.categoryId,
                  subCatId: widget.provider.subCategoryId,
                  itemTypeId: widget.provider.itemTypeId,
                  conditionOfItemId: widget.provider.itemConditionId,
                  itemPriceTypeId: widget.provider.itemPriceTypeId,
                  itemCurrencyId: widget.provider.itemCurrencyId,
                  price: widget.userInputPrice.text,
                  dealOptionId: widget.provider.itemDealOptionId,
                  itemLocationId: widget.provider.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider.itemLocationTownshipId,
                  businessMode: widget.provider.checkOrNotShop,
                  isSoldOut: widget.item.isSoldOut,
                  title: widget.userInputListingTitle.text,
                  brand: widget.userInputBrand.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation.text,
                  description: widget.userInputDescription.text,
                  dealOptionRemark: widget.userInputDealOptionText.text,
                  latitude: widget.userInputLattitude.text,
                  longitude: widget.userInputLongitude.text,
                  address: widget.userInputAddress.text,
                  id: widget.item.id,
                  addedUserId: widget.provider.psValueHolder.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider
                    .postItemEntry(itemEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  if (itemData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);

                    if (widget.isSelectedFirstImagePath ||
                        widget.isSelectedSecondImagePath ||
                        widget.isSelectedThirdImagePath ||
                        widget.isSelectedFouthImagePath ||
                        widget.isSelectedFifthImagePath) {
                      widget.uploadImage(itemData.data.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              }
            }
          },
        ));

    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
        // height: 50,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__category'),
        textEditingController: widget.categoryController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult =
              await Navigator.pushNamed(context, RoutePaths.searchCategory);

          if (categoryResult != null && categoryResult is Category) {
            provider.categoryId = categoryResult.catId;
            widget.categoryController.text = categoryResult.catName;
            provider.subCategoryId = '';

            setState(() {
              widget.categoryController.text = categoryResult.catName;
              widget.subCategoryController.text = '';
            });
          }
        },
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__subCategory'),
          textEditingController: widget.subCategoryController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            if (provider.categoryId != '') {
              final dynamic subCategoryResult = await Navigator.pushNamed(
                  context, RoutePaths.searchSubCategory,
                  arguments: provider.categoryId);
              if (subCategoryResult != null &&
                  subCategoryResult is SubCategory) {
                provider.subCategoryId = subCategoryResult.id;

                widget.subCategoryController.text = subCategoryResult.name;
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'home_search__choose_category_first'),
                    );
                  });
              const ErrorDialog(message: 'Choose Category first');
            }
          }),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__type'),
          textEditingController: widget.typeController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemTypeResult =
                await Navigator.pushNamed(context, RoutePaths.itemType);

            if (itemTypeResult != null && itemTypeResult is ItemType) {
              provider.itemTypeId = itemTypeResult.id;

              setState(() {
                widget.typeController.text = itemTypeResult.name;
              });
            }
          }),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__item_condition'),
          textEditingController: widget.itemConditionController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemConditionResult =
                await Navigator.pushNamed(context, RoutePaths.itemCondition);

            if (itemConditionResult != null &&
                itemConditionResult is ConditionOfItem) {
              provider.itemConditionId = itemConditionResult.id;

              setState(() {
                widget.itemConditionController.text = itemConditionResult.name;
              });
            }
          }),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__brand'),
      //   textAboutMe: false,
      //   textEditingController: widget.userInputBrand,
      // ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__price_type'),
          textEditingController: widget.priceTypeController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemPriceTypeResult =
                await Navigator.pushNamed(context, RoutePaths.itemPriceType);

            if (itemPriceTypeResult != null &&
                itemPriceTypeResult is ItemPriceType) {
              provider.itemPriceTypeId = itemPriceTypeResult.id;
              // provider.subCategoryId = '';

              setState(() {
                widget.priceTypeController.text = itemPriceTypeResult.name;
                // provider.selectedSubCategoryName = '';
              });
            }
          }),
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController,
          userInputPriceController: widget.userInputPrice),
      const SizedBox(height: PsDimens.space8),
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space6),
            child: Text(Utils.getString(context, 'item_entry__for_free_item'),
                style: Theme.of(context).textTheme.bodyText2.copyWith(color:Utils.isLightMode(context)? PsColors.mainColor:Colors.white)),
          ),
          const SizedBox(height: PsDimens.space6),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12),
            child: Text(Utils.getString(context, 'item_entry__shop_setting'),
                style: Theme.of(context).textTheme.bodyText2),
          ),
          BusinessModeCheckbox(
            provider: widget.provider,
            onCheckBoxClick: () {
              setState(() {
                updateCheckBox(context, widget.provider);
              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: PsColors.categoryBackgroundColor,
            padding: const EdgeInsets.only(top:PsDimens.space6, bottom: PsDimens.space6, left: PsDimens.space16),
            child: Text(
                Utils.getString(context, 'item_entry__show_more_than_one'),
                style: Theme.of(context).textTheme.caption.copyWith(color:Utils.isLightMode(context)? PsColors.mainColor:Colors.white,fontWeight:FontWeight.w400)),
          ),
        ],
      ),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__highlight_info'),
      //   height: PsDimens.space120,
      //   hintText: Utils.getString(context, 'item_entry__highlight_info'),
      //   // textAboutMe: true,
      //   maxLine: 8,
      //   keyboardType: TextInputType.multiline,
      //   textEditingController: widget.userInputHighLightInformation,
      // ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        // textAboutMe: true,
        maxLine: 8,
        keyboardType: TextInputType.multiline,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      Column(
        children: <Widget>[
          PsDropdownBaseWithControllerWidget(
              title: Utils.getString(context, 'item_entry__deal_option'),
              textEditingController: widget.dealOptionController,
              isStar: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemDealOptionResult = await Navigator.pushNamed(
                    context, RoutePaths.itemDealOption);

                if (itemDealOptionResult != null &&
                    itemDealOptionResult is DealOption) {
                  provider.itemDealOptionId = itemDealOptionResult.id;

                  setState(() {
                    widget.dealOptionController.text =
                        itemDealOptionResult.name;
                  });
                }
              }),
          // Container(
          //   width: double.infinity,
          //   height: PsDimens.space48,
          //   margin: const EdgeInsets.only(
          //       left: PsDimens.space12,
          //       right: PsDimens.space12,
          //       bottom: PsDimens.space12),
          //   decoration: BoxDecoration(
          //     color:
          //         Utils.isLightMode(context) ? Colors.white60 :  PsColors.backgroundColor,
          //     borderRadius: BorderRadius.circular(PsDimens.space4),
          //     border: Border.all(
          //         color: Utils.isLightMode(context)
          //             ? Colors.grey[200]
          //             : PsColors.backgroundColor),
          //   ),
          //   child: TextField(
          //     keyboardType: TextInputType.text,
          //     maxLines: null,
          //     controller: widget.userInputDealOptionText,
          //     style: Theme.of(context).textTheme.bodyText1,
          //     decoration: InputDecoration(
          //       contentPadding: const EdgeInsets.only(
          //         left: PsDimens.space12,
          //         bottom: PsDimens.space8,
          //       ),
          //         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
          //               border: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor)),
          //               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
                  
          //       hintText: Utils.getString(context, 'item_entry__remark'),
          //       hintStyle: Theme.of(context)
          //           .textTheme
          //           .bodyText2
          //           .copyWith(color: PsColors.textPrimaryLightColor),
          //     ),
          //   ),
          // )
        ],
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          // selectedText: provider.selectedItemLocation == ''
          //     ? provider.psValueHolder.locactionName
          //     : provider.selectedItemLocation,

          textEditingController:
              // locationController.text == ''
              // ?
              // provider.psValueHolder.locactionName
              // :
              widget.locationController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult =
                await Navigator.pushNamed(context, RoutePaths.itemLocation);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocation) {
              provider.itemLocationId = itemLocationResult.id;
              setState(() {
                widget.locationController.text = itemLocationResult.name;
                if (PsConfig.isUseGoogleMap &&
                    valueHolder.isSubLocation == PsConst.ZERO) {
                  _kLake = googlemap.CameraPosition(
                      target:
                          googlemap.LatLng(_latlng.latitude, _latlng.longitude),
                      zoom: widget.zoom);
                  if (_kLake != null) {
                    widget.googleMapController.animateCamera(
                        googlemap.CameraUpdate.newCameraPosition(_kLake));
                  }
                  widget.userInputLattitude.text = itemLocationResult.lat;
                  widget.userInputLongitude.text = itemLocationResult.lng;
                } else if (!PsConfig.isUseGoogleMap &&
                    valueHolder.isSubLocation == PsConst.ZERO) {
                  _latlng = LatLng(double.parse(itemLocationResult.lat),
                      double.parse(itemLocationResult.lng));
                  widget.mapController.move(_latlng, widget.zoom);
                  widget.userInputLattitude.text = itemLocationResult.lat;
                  widget.userInputLongitude.text = itemLocationResult.lng;
                } else {
                  //do nothing
                }

                widget.locationTownshipController.text = '';
                provider.itemLocationTownshipId = '';
                widget.userInputAddress.text = '';
              });
            }
          }),
      if (valueHolder.isSubLocation == PsConst.ONE)
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__location_township'),
            textEditingController: widget.locationTownshipController,
            isStar: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
                  Provider.of<ItemEntryProvider>(context, listen: false);
              if (provider.itemLocationId != '') {
                final dynamic itemLocationTownshipResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemLocationTownship,
                        arguments: provider.itemLocationId);

                if (itemLocationTownshipResult != null &&
                    itemLocationTownshipResult is ItemLocationTownship) {
                  provider.itemLocationTownshipId =
                      itemLocationTownshipResult.id;
                  setState(() {
                    widget.locationTownshipController.text =
                        itemLocationTownshipResult.townshipName;
                    if (PsConfig.isUseGoogleMap) {
                      _kLake = googlemap.CameraPosition(
                          target: googlemap.LatLng(
                              _latlng.latitude, _latlng.longitude),
                          zoom: widget.zoom);
                      if (_kLake != null) {
                        widget.googleMapController.animateCamera(
                            googlemap.CameraUpdate.newCameraPosition(_kLake));
                      }
                    } else {
                      _latlng = LatLng(
                          double.parse(itemLocationTownshipResult.lat),
                          double.parse(itemLocationTownshipResult.lng));
                      widget.mapController.move(_latlng, widget.zoom);
                    }
                    widget.userInputLattitude.text =
                        itemLocationTownshipResult.lat;
                    widget.userInputLongitude.text =
                        itemLocationTownshipResult.lng;

                    widget.userInputAddress.text = '';
                  });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_city_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose City first');
              }
            })
      else
        Container(),
      if (!PsConfig.isUseGoogleMap)
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress,
              latController: widget.userInputLattitude,
              lngController: widget.userInputLongitude,
              valueHolder: valueHolder,
              updateLatLng: (Position currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    widget.mapController.move(_latlng, widget.zoom);
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Container(
                height: 250,
                child: FlutterMap(
                  mapController: widget.mapController,
                  options: MapOptions(
                      center:
                          _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: widget.zoom, //10.0,
                      onTap: (LatLng latLngr) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _handleTap(_latlng, widget.mapController);
                      }),
                  layers: <LayerOptions>[
                    TileLayerOptions(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayerOptions(markers: <Marker>[
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _latlng,
                        builder: (BuildContext ctx) => Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: PsColors.mainColor,
                            ),
                            iconSize: 45,
                            onPressed: () {},
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ],
        )
      else
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress,
              latController: widget.userInputLattitude,
              lngController: widget.userInputLongitude,
              valueHolder: valueHolder,
              updateLatLng: (Position currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng.latitude, _latlng.longitude),
                        zoom: widget.zoom);
                    if (_kLake != null) {
                      widget.googleMapController.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake));
                    }
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: Container(
                height: 250,
                child: googlemap.GoogleMap(
                    onMapCreated: widget.updateMapController,
                    initialCameraPosition: kGooglePlex,
                    circles: <googlemap.Circle>{}..add(googlemap.Circle(
                        circleId: googlemap.CircleId(
                            widget.userInputAddress.toString()),
                        center: googlemap.LatLng(
                            _latlng.latitude, _latlng.longitude),
                        radius: 50,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )),
                    onTap: (googlemap.LatLng latLngr) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _handleGoogleMapTap(_latlng, widget.googleMapController);
                    }),
              ),
            ),
          ],
        ),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__latitude'),
      //   textAboutMe: false,
      //   textEditingController: widget.userInputLattitude,
      // ),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__longitude'),
      //   textAboutMe: false,
      //   textEditingController: widget.userInputLongitude,
      // ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__address'),
        textAboutMe: false,
        height: PsDimens.space160,
        textEditingController: widget.userInputAddress,
        hintText: Utils.getString(context, 'item_entry__address'),
      ),
      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        mapController.move(_latlng, widget.zoom);
        widget.userInputAddress.text = result.address;
        widget.userInputAddress.text = '';
        // tappedPoints = <LatLng>[];
        // tappedPoints.add(latlng);
      });
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }

  dynamic _handleGoogleMapTap(
      LatLng latLng, googlemap.GoogleMapController googleMapController) async {
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString()));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng.latitude, result.latLng.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng.latitude, _latlng.longitude),
            zoom: widget.zoom);
        if (_kLake != null) {
          googleMapController
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake));
          widget.userInputAddress.text = result.address;
          widget.userInputAddress.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }
}

class   ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList(
      {@required this.flag,
      @required this.images,
      @required this.selectedImageList,
      @required this.updateImages,
      @required this.updateImagesFromCustomCamera,
      @required this.firstImagePath,
      @required this.secondImagePath,
      @required this.thirdImagePath,
      @required this.fouthImagePath,
      @required this.fifthImagePath,
      @required this.firstCameraImagePath,
      @required this.secondCameraImagePath,
      @required this.thirdCameraImagePath,
      @required this.fouthCameraImagePath,
      @required this.fifthCameraImagePath});
  final String flag;
  final List<Asset> images;
  final List<DefaultPhoto> selectedImageList;
  final Function updateImages;
  final Function updateImagesFromCustomCamera;
  final Asset firstImagePath;
  final Asset secondImagePath;
  final Asset thirdImagePath;
  final Asset fouthImagePath;
  final Asset fifthImagePath;
  final String firstCameraImagePath;
  final String secondCameraImagePath;
  final String thirdCameraImagePath;
  final String fouthCameraImagePath;
  final String fifthCameraImagePath;
  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  ItemEntryProvider provider;
  Future<void> loadPickMultiImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        // selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages(resultList, -1);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: widget.images, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    if (resultList[0].name.contains('.webp')) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__webp_image'),
            );
          });
    } else {
      widget.updateImages(resultList, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    Asset defaultAssetImage;
    DefaultPhoto defaultUrlImage;
    provider = Provider.of<ItemEntryProvider>(context, listen: false);

    final Widget _defaultWidget = Container(
      width: 65,
      height: 25,
      // decoration: const ShapeDecoration(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(0.0)),
      //   ),
      // ),
      // alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
          top: PsDimens.space4, left: PsDimens.space6, right: PsDimens.space4),
      child: Material(
        color: PsColors.soldOutUIColor,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(PsDimens.space16))),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__default_image'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: PsColors.white),
            ),
          ),
        ),
      ),
    );
    // Container(
    //     width: 100,
    //     child: PSButtonWidgetRoundCorner(
    //       hasShadow: true,
    //       width: double.infinity,
    //       titleText: Utils.getString(context, 'item_entry__default_image'),
    //       onPressed: () async {},
    //     ));

    return Container(
      height: PsDimens.space140,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    
                    ItemEntryImageWidget(
                      index: 0,
                      images: (widget.firstImagePath != null)
                          ? widget.firstImagePath
                          : defaultAssetImage,
                      cameraImagePath: (widget.firstCameraImagePath != null)
                          ? widget.firstCameraImagePath
                          : defaultAssetImage,
                      selectedImage: (widget.selectedImageList.isNotEmpty &&
                              widget.firstImagePath == null &&
                              widget.firstCameraImagePath == null)
                          ? widget.selectedImageList[0]
                          : null,
                      onDeletItemImage: () {},
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (provider.psValueHolder.isCustomCamera ?? true) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ChooseCameraTypeDialog(
                                  onCameraTap: () async {
                                    final dynamic returnData =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.cameraView);
                                    if (returnData is String) {
                                      widget.updateImagesFromCustomCamera(
                                          returnData, 0);
                                    }
                                  },
                                  onGalleryTap: () {
                                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                      loadPickMultiImage();
                                    } else {
                                      loadSingleImage(0);
                                    }
                                  },
                                );
                              });
                        } else {
                          if (widget.flag == PsConst.ADD_NEW_ITEM) {
                            loadPickMultiImage();
                          } else {
                            loadSingleImage(0);
                          }
                        }
                      },
                    ),
                    Positioned(
                      child: _defaultWidget,
                      left: PsDimens.space12,
                      right: PsDimens.space12,
                      top: -8,
                    ),
                  ],
                ),
                ItemEntryImageWidget(
                  index: 1,
                  images: (widget.secondImagePath != null)
                      ? widget.secondImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.secondCameraImagePath != null)
                      ? widget.secondCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.secondImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 1 &&
                              widget.secondImagePath == null &&
                              widget.secondCameraImagePath == null)
                          ? widget.selectedImageList[1]
                          : null,
                  onDeletItemImage: () {
                    setState(() {
                      final ItemEntryProvider itemEntryProvider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      itemEntryProvider.secondImageId = '';
                      widget.selectedImageList[1] = null;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 1);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(1);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(1);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 2,
                  images: (widget.thirdImagePath != null)
                      ? widget.thirdImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.thirdCameraImagePath != null)
                      ? widget.thirdCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.thirdImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 2 &&
                              widget.thirdImagePath == null &&
                              widget.thirdCameraImagePath == null)
                          ? widget.selectedImageList[2]
                          : defaultUrlImage,
                  onDeletItemImage: () {
                    setState(() {
                      final ItemEntryProvider itemEntryProvider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      itemEntryProvider.thirdImageId = '';
                      widget.selectedImageList[2] = null;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 2);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(2);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(2);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 3,
                  images: (widget.fouthImagePath != null)
                      ? widget.fouthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fouthCameraImagePath != null)
                      ? widget.fouthCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.fouthImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 3 &&
                              widget.fouthImagePath == null &&
                              widget.fouthCameraImagePath == null)
                          ? widget.selectedImageList[3]
                          : defaultUrlImage,
                  onDeletItemImage: () {
                    setState(() {
                      final ItemEntryProvider itemEntryProvider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      itemEntryProvider.fourthImageId = '';
                      widget.selectedImageList[3] = null;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 3);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(3);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(3);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 4,
                  images: (widget.fifthImagePath != null)
                      ? widget.fifthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fifthCameraImagePath != null)
                      ? widget.fifthCameraImagePath
                      : defaultAssetImage,
                  selectedImage: //widget.fifthImagePath != null ||
                      //     widget.selectedImageList.length - 1 >= 4)
                      // ? widget.selectedImageList[4]
                      // : defaultUrlImage,
                      (widget.selectedImageList.length > 4 &&
                              widget.fifthImagePath == null &&
                              widget.fifthCameraImagePath == null)
                          ? widget.selectedImageList[4]
                          : null,
                  onDeletItemImage: () {
                    setState(() {
                      final ItemEntryProvider itemEntryProvider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      itemEntryProvider.fiveImageId = '';
                      widget.selectedImageList[4] = null;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 4);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(4);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(4);
                      }
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget(
      {Key key,
      @required this.index,
      @required this.images,
      @required this.cameraImagePath,
      @required this.selectedImage,
      this.onTap,
      @required this.onDeletItemImage})
      : super(key: key);

  final Function onTap;
  final Function onDeletItemImage;
  final int index;
  final Asset images;
  final String cameraImagePath;
  final DefaultPhoto selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  GalleryProvider galleryProvider;
  PsValueHolder valueHolder;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    galleryProvider = Provider.of<GalleryProvider>(context, listen: false);
    final Widget _deleteWidget = Container(
      
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_image'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.selectedImage.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await galleryProvider.deleItemImage(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      widget.onDeletItemImage();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    if (widget.selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: PsNetworkImageWithUrl(
                  photoKey: '',
                  // width: 100,
                  // height: 100,
                  imagePath: widget.selectedImage.imgPath,
                ),
              ),
              Positioned(
                child: widget.index == 0 ? Container() : _deleteWidget,
                right: 1,
                bottom: 1,
              )
            ],
          ),
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
              onTap: widget.onTap,
              child: Image(
                  width: 100,
                  height: 100,
                  image: FileImage(File(widget.cameraImagePath)))),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: SvgPicture.asset(
              'assets/images/icons/UploadImage.svg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController currencySymbolController;
  final TextEditingController userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: PsDimens.space8),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : PsColors.backgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
                    contentPadding: const EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id;

                  currencySymbolController.text =
                      itemCurrencySymbolResult.currencySymbol;
                }
              },
              child: Container(
                width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : PsColors.backgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color:PsColors.mainColor
                          ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Text(
                              currencySymbolController.text == ''
                                  ? Utils.getString(
                                      context, 'home_search__not_set')
                                  : currencySymbolController.text,
                              style: currencySymbolController.text == ''
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.grey[600])
                                  : Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                       SvgPicture.asset('assets/images/icons/DropdownRow.svg')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider provider;
  final Function onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          const  SizedBox(width: PsDimens.space24,),
          InkWell(onTap: (){
                widget.onCheckBoxClick();
          },child: widget.provider.isCheckBoxSelect
              ?  Icon(
                  Icons.check_box_outlined,
                  size: 26.0,
                  color: PsColors.mainColor,
                )
              :  Icon(
                  Icons.check_box_outline_blank,
                  size: 26.0,
                  color: PsColors.mainColor,
                )),
                const SizedBox(width: PsDimens.space8,),
          Expanded(
            child: InkWell(
              child: Text(Utils.getString(context, 'item_entry__is_shop'),
                  style: Theme.of(context).textTheme.bodyText1),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.onCheckBoxClick();
              },
            ),
          ),
        ],
      ),
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
    @required this.textEditingController,
    @required this.latController,
    @required this.lngController,
    @required this.valueHolder,
    @required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController textEditingController;
  final TextEditingController latController;
  final TextEditingController lngController;
  final PsValueHolder valueHolder;
  final Function updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    _initCurrentLocation();
  }

  dynamic loadAddress() async {
    if (_currentPosition != null) {
      final List<Address> addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(
              _currentPosition.latitude, _currentPosition.longitude));
      final Address first = addresses.first;
      address = '${first.addressLine}, ${first.countryName}';
      setState(() {
        widget.textEditingController.text = address;
        widget.latController.text = _currentPosition.latitude.toString();
        widget.lngController.text = _currentPosition.longitude.toString();
        widget.updateLatLng(_currentPosition);
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator
            //..forceAndroidLocationManager = !widget.androidFusedLocation
            .getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium,
                forceAndroidLocationManager: !widget.androidFusedLocation)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    }).catchError((Object e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_currentPosition == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'map_pin__open_gps'),
                      onPressed: () {},
                    );
                  });
            } else {
              loadAddress();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(PsDimens.space16)),
              ),
              color: PsColors.baseLightColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: PsDimens.space32,
                        width: PsDimens.space32,
                        child: Icon(
                          Icons.gps_fixed,
                          color: PsColors.mainColor,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        if (_currentPosition == null) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context, 'map_pin__open_gps'),
                                  onPressed: () {},
                                );
                              });
                        } else {
                          loadAddress();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        Utils.getString(context, 'item_entry_pick_location'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            letterSpacing: 0.8, fontSize: 16, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
