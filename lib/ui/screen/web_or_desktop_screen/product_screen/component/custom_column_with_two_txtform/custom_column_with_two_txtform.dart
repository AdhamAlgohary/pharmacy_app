import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/widgets/custom_btn/custom_btn.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt_form_field/custom_txt_form_field.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/screen_size/screen_size.dart';

// ignore: must_be_immutable
class CustomColumnWithTwoTxtForm extends StatefulWidget {
  int index;
  final String hintText1;
  final String hintText2;
  final String ifBody1;
  final String ifBody2;
  final String regExpSource1;
  final String regExpSource;
  final TextEditingController chemicalController;
  final TextEditingController numberOfChemicalsController;
  final TextEditingController? expireDateController;
  void Function()? function;
  bool Function()? chemicalValidate;
  void Function()? addProductValidate;
  TextEditingController? amountController;
  GlobalKey<FormState>? amountKey;
  final GlobalKey<FormState> newNameProductKey;
  final String titleTxt;
  CustomColumnWithTwoTxtForm({
    Key? key,
    this.amountController,
    this.amountKey,
    required this.index,
    required this.hintText1,
    required this.hintText2,
    required this.ifBody1,
    required this.regExpSource,
    required this.chemicalController,
    required this.titleTxt,
    required this.regExpSource1,
    required this.newNameProductKey,
    required this.ifBody2,
    this.function,
    this.chemicalValidate,
    this.addProductValidate,
    required this.numberOfChemicalsController,
    this.expireDateController,
  }) : super(key: key);

  @override
  State<CustomColumnWithTwoTxtForm> createState() =>
      _CustomColumnWithTwoTxtFormState();
}

class _CustomColumnWithTwoTxtFormState
    extends State<CustomColumnWithTwoTxtForm> {
  Box myBox = Hive.box<ChemicalModel>('chemicalInfo');
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.only(top: 0.3 * height, bottom: 0.01 * height),
        child: CustomTxt(
            txt: '${widget.titleTxt} ${widget.index}', txtStyle: style1),
      ),
      CustomTxtFormField(
        obScure: false,
        regExpSource: widget.regExpSource1,
        hintText: widget.hintText1,
        textEditingController: widget.chemicalController,
        autovalidateMode: AutovalidateMode.disabled,
        caseSensitive: false,
        keyBoardType: TextInputType.name,
        myKey: widget.newNameProductKey,
        ifBody: widget.ifBody2,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.01 * height),
        child: CustomTxtFormField(
            obScure: false,
            regExpSource: widget.regExpSource,
            ifBody: widget.ifBody1,
            hintText: widget.hintText2,
            textEditingController: widget.amountController,
            myKey: widget.amountKey,
            autovalidateMode: AutovalidateMode.disabled,
            caseSensitive: false,
            keyBoardType: TextInputType.datetime,
            function: widget.function),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: 0.02 * getHeight(context: context),
            right: 0.1 * width,
            left: 0.1 * width),
        child: CustomBtn(
          color: Colors.transparent,
          txt: 'Add Chemical ${widget.index}',
          textStyle: style4,
          height: 0.05 * height,
          width: 0.7 * width,
          function: () {
            if (widget.index <
                int.parse(widget.numberOfChemicalsController.text)) {
              if (widget.chemicalValidate!()) {
                widget.chemicalController.clear();
                widget.amountController!.clear();
                setState(() {
                  widget.index++;
                });
              }
            } else if (widget.index ==
                double.parse(widget.numberOfChemicalsController.text)) {
              widget.addProductValidate!();
              widget.chemicalController.clear();
              widget.amountController!.clear();
              widget.numberOfChemicalsController.clear();
              widget.expireDateController!.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please enter the correct number of chemicals'),
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
      )
    ]);
  }
}
