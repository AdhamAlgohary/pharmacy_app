import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/model/product_model/product_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/component/back_ground_container.dart';
import 'package:pharmacy_app/ui/widgets/custom_btn/custom_btn.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/product_screen/component/custom_column_with_two_txtform/custom_column_with_two_txtform.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt_form_field/custom_txt_form_field.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/functions/const_functions/const_functions.dart';
import 'package:pharmacy_app/utilits/functions/const_widget_functins/const_widget_functions.dart';
import 'package:pharmacy_app/utilits/screen_size/screen_size.dart';
import 'package:pharmacy_app/view-model/product_view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late int index;
  late GlobalKey<FormState> productKey;
  late GlobalKey<FormState> chemicalKey;
  late GlobalKey<FormState> amountKey;
  late GlobalKey<FormState> numberOfChemicalsKey;
  late GlobalKey<FormState> expireKey;
  // late GlobalKey<FormState> expireKey;
  late TextEditingController productController;
  late TextEditingController chemicalController;
  late TextEditingController amountController;
  late TextEditingController expireDateController;
  late TextEditingController numberOfChemicalsController;
  late Box myBox;
  late Box myBox1;
  // late double totalPriceOfGrams;
  late List<Map<String, dynamic>> chemicals;
  late List<Map<String, dynamic>> chemicals2;
  // late bool hasAdham;
  // String expire = null.toString();

  @override
  void initState() {
    productKey = GlobalKey<FormState>();
    numberOfChemicalsKey = GlobalKey<FormState>();
    expireKey = GlobalKey<FormState>();
    amountKey = GlobalKey<FormState>();
    chemicalKey = GlobalKey<FormState>();
    productController = TextEditingController();
    chemicalController = TextEditingController();
    amountController = TextEditingController();
    expireDateController = TextEditingController();
    numberOfChemicalsController = TextEditingController();
    // expireKey = GlobalKey<FormState>();
    myBox = Hive.box<ChemicalModel>('chemicalinfo');
    myBox1 = Hive.box<ProductModel>('productinfo');
    index = 0;
    // totalPriceOfGrams = 0;
    chemicals = [];
    chemicals2 = [];

    super.initState();
  }

  @override
  void dispose() {
    productController.dispose();
    chemicalController.dispose();
    amountController.dispose();
    expireDateController.dispose();
    numberOfChemicalsController.dispose();
    super.dispose();
  }

  bool chemicalValidate() {
    var amountData = amountKey.currentState;
    bool hasAdham = false;

    if (myBox.keys.contains(chemicalController.text.toUpperCase().trim()) &&
        amountData!.validate() &&
        double.parse(amountController.text) <=
            myBox
                .get(chemicalController.text.toUpperCase().trim())
                .gramsOfChemical &&
        myBox
                .get(chemicalController.text.toUpperCase().trim())
                .gramsOfChemical !=
            0) {
      for (final e in chemicals) {
        if (e.containsValue(chemicalController.text.toUpperCase().trim())) {
          hasAdham = true;
        }
      }

      if (index > 1 && hasAdham) {
        chemicals[chemicals.indexWhere((element) => element
                .containsValue(chemicalController.text.toUpperCase().trim()))]
            ['amountOfChemical'] += double.parse(amountController.text);
        chemicals[chemicals.indexWhere((element) =>
                element.containsValue(chemicalController.text.toUpperCase().trim()))]
            ['priceOfAmountOfChemical'] = chemicals[chemicals.indexWhere(
                    (element) => element
                        .containsValue(chemicalController.text.toUpperCase().trim()))]
                ['amountOfChemical'] *
            myBox
                .get(chemicalController.text.toUpperCase().trim())
                .priceOfgramsOfChemical;
        setState(() {
          index++;
          checkDebugMode(chemicals);
          chemicalController.clear();
        });
        return true;
      } else {
        setState(() {
          chemicals.add({
            'nameOfChemical': chemicalController.text.toUpperCase().trim(),
            'amountOfChemical': double.parse(amountController.text),
            'priceOfAmountOfChemical': double.parse(amountController.text) *
                myBox
                    .get(chemicalController.text.toUpperCase().trim())
                    .priceOfgramsOfChemical
          });

          index++;
          chemicalController.clear();
          amountController.clear();
        });
        return true;
      }
    } else {
      showAwsomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'This Chemical is not exist or grams of chemical is not valid or Quantity is greater than available');
      return false;
    }
  }

  void nameProductValidate() {
    var productDate = productKey.currentState;
    var numberOfChemicalsDate = numberOfChemicalsKey.currentState;

    var expireData = expireKey.currentState;

    if (productDate!.validate() &&
        numberOfChemicalsDate!.validate() &&
        expireData!.validate() &&
        int.tryParse(numberOfChemicalsController.text) != null) {
      if (index == 0) {
        chemicalController.clear();
        // numberOfChemicalsController.clear();
        // expireDateController.clear();
        setState(() {
          index++;
        });
      }
    }
  }

  void addProductValidate() {
    double totalPriceOfGrams = 0;
    if (myBox1.keys.contains(productController.text.toUpperCase().trim())) {
      myBox1.get(productController.text.toUpperCase().trim()).nameOfProduct =
          productController.text;
      myBox1
          .get(productController.text.toUpperCase().trim())
          .expireDateOfProduct = expireDateController.text;
      if (chemicalValidate() == true) {
        chemicals2.addAll(chemicals);
        for (final e in chemicals) {
          totalPriceOfGrams +=
              chemicals[chemicals.indexOf(e)]['priceOfAmountOfChemical'];

          myBox
                  .get(chemicals2[chemicals2.indexOf(e)]['nameOfChemical']
                      .toString()
                      .toUpperCase()
                      .trim())
                  .gramsOfChemical -=
              chemicals2[chemicals2.indexOf(e)]['amountOfChemical'];
          myBox
                  .get(chemicals2[chemicals2.indexOf(e)]['nameOfChemical']
                      .toString()
                      .toUpperCase()
                      .trim())
                  .kiloOfChemical -=
              chemicals2[chemicals2.indexOf(e)]['amountOfChemical'] / 1000;
        }
        Provider.of<ProductViewModel>(context, listen: false).addProduct(
            productController.text.toUpperCase().trim(),
            totalPriceOfGrams,
             expireDateController.text.toUpperCase().trim(),
            chemicals2);
        productController.clear();
        checkDebugMode(chemicals2);
        index = 0;
        chemicals = [];
        chemicals2 = [];
        totalPriceOfGrams = 0;
        showAwsomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Congrates!',
          desc: 'Product Adedd succefully',
        );
      }
    } else {
      if (chemicalValidate() == true) {
        chemicals2.addAll(chemicals);
        for (final e in chemicals) {
          totalPriceOfGrams +=
              chemicals[chemicals.indexOf(e)]['priceOfAmountOfChemical'];

          myBox
                  .get(chemicals2[chemicals2.indexOf(e)]['nameOfChemical']
                      .toString()
                      .toUpperCase()
                      .trim())
                  .gramsOfChemical -=
              chemicals2[chemicals2.indexOf(e)]['amountOfChemical'];
          myBox
                  .get(chemicals2[chemicals2.indexOf(e)]['nameOfChemical']
                      .toString()
                      .toUpperCase()
                      .trim())
                  .kiloOfChemical -=
              chemicals2[chemicals2.indexOf(e)]['amountOfChemical'] / 1000;
        }
        Provider.of<ProductViewModel>(context, listen: false).addProduct(
            productController.text.toUpperCase().trim(),
            totalPriceOfGrams,
            expireDateController.text.toUpperCase().trim(),
            chemicals2);
        checkDebugMode(chemicals2);

        index = 0;
        chemicals = [];
        chemicals2 = [];
        productController.clear();
        showAwsomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Congrates!',
            desc: 'Product Adedd succefully');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.08 * height),
        child: AppBar(
          backgroundColor: Colors.lightBlue[100],
          centerTitle: true,
          title: CustomTxt(
              txt: 'Add Product',
              txtStyle: style1.copyWith(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          const BackGroundContainr(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.6 * height),
            child: index == 0
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.3 * getHeight(context: context)),
                        child: CustomTxtFormField(
                          hintText: 'Name Of Product',
                          obScure: false,
                          regExpSource:
                              r'\w(\d)?|[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]',
                          ifBody: 'Please enter name of product',
                          myKey: productKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textEditingController: productController,
                          caseSensitive: false,
                          keyBoardType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.01 * height),
                        child: CustomTxtFormField(
                          obScure: false,
                          regExpSource: r'^(?!0+$)[0-9]+$',
                          ifBody: 'Please enter number of chemicals in product',
                          hintText: 'Number of chemicals in product',
                          textEditingController: numberOfChemicalsController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          caseSensitive: false,
                          myKey: numberOfChemicalsKey,
                          keyBoardType: TextInputType.number,
                        ),
                      ),
                      CustomTxtFormField(
                        obScure: false,
                        regExpSource: r'^[+]?(\d){4}-(\d){2}-(\d){2}$',
                        ifBody: 'please enter date in form 2025-02-25',
                        hintText: 'Expire Date',
                        textEditingController: expireDateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        caseSensitive: false,
                        myKey: expireKey,
                        keyBoardType: TextInputType.datetime,
                        function: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2100))
                              .then((value) {
                            setState(() {
                              if (value != null) {
                                expireDateController.text =
                                    value.toString().split(' ')[0];
                              }
                            });
                          });
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 0.04 * getHeight(context: context),
                              right: 0.1 * width,
                              left: 0.1 * width),
                          child: CustomBtn(
                            color: Colors.transparent,
                            txt: 'Add Chemicals',
                            textStyle: style4,
                            height: 0.05 * height,
                            width: 0.7 * width,
                            function: () {
                              nameProductValidate();
                            },
                          )),
                    ],
                  )
                : CustomColumnWithTwoTxtForm(
                    index: index,
                    hintText1: 'Name of chemical',
                    hintText2: 'Amount (Grams)',
                    ifBody1: 'please enter amount in grams',
                    chemicalController: chemicalController,
                    chemicalValidate: chemicalValidate,
                    addProductValidate: addProductValidate,
                    numberOfChemicalsController: numberOfChemicalsController,
                    regExpSource: r'^[+]?([.]\d+|\d+([.]\d+)?)$',
                    titleTxt: 'Chemical',
                    regExpSource1: '',
                    newNameProductKey: chemicalKey,
                    ifBody2: '',
                    amountKey: amountKey,
                    amountController: amountController,
                    expireDateController: expireDateController,
                  ),
          ),
        ],
      ),
    );
  }
}
