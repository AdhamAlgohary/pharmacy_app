import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/repo/services/chemical_storage_hive_service/chemical_storage_hive_service.dart';
import 'package:pharmacy_app/utilits/functions/const_functions/const_functions.dart';
import 'package:pharmacy_app/utilits/functions/const_widget_functins/const_widget_functions.dart';

class ChemiclaFunctions {
  static addChemical({
    required BuildContext context,
    required GlobalKey<FormState> amountKey,
    required GlobalKey<FormState> priceKey,
    required GlobalKey<FormState> nameKey,
    required Box myBox,
    required TextEditingController expireController,
    required TextEditingController nameController,
    required TextEditingController amountController,
    required TextEditingController priceController,
  }) {
    var formData1 = amountKey.currentState;
    var formData3 = priceKey.currentState;
    var formData4 = nameKey.currentState;
    try {
      if (formData1!.validate() &&
          formData3!.validate() &&
          formData4!.validate()) {
        if (myBox.keys.contains(nameController.text.toUpperCase().trim())) {
          myBox.get(nameController.text.toUpperCase().trim()).kiloOfChemical +=
              double.parse(amountController.text);
          myBox
              .get(nameController.text.toUpperCase().trim())
              .expireDateOfChemical = expireController.text;

          myBox
              .get(nameController.text.toUpperCase().trim())
              .priceOfKiloOfChemical = double.parse(priceController.text);
          nameController.clear();
          amountController.clear();
          priceController.clear();
          expireController.clear();
          showAwsomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Congrates!',
              desc: 'Added Successfully');
        } else {
          ChemicalStorageHiveService.auth.addChemical(
            nameController.text.toUpperCase().trim(),
            double.parse(amountController.text),
            double.parse(priceController.text),
            expireController.text.toUpperCase().trim(),
          );
          nameController.clear();
          amountController.clear();
          priceController.clear();
          expireController.clear();

          showAwsomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: "Congrates!",
              desc: 'Added successfully');
        }
      } else {}
      // ignore: empty_catches
    } catch (e) {
      checkDebugMode(e);
    }
  }

  static  edit({
    required BuildContext context,
    required GlobalKey<FormState> amountKey,
    required GlobalKey<FormState> priceKey,
    required TextEditingController editNameController,
    required String chemicalOldName,
    required TextEditingController amountController,
    required TextEditingController priceController,
    required TextEditingController expireController,
  }) {
    var formData1 = amountKey.currentState;
    var formData3 = priceKey.currentState;
    try {
      if (formData1!.validate() && formData3!.validate()) {
        ChemicalStorageHiveService.auth
            .deleteChemical(chemicalOldName.toUpperCase().trim());
        ChemicalStorageHiveService.auth.addChemical(
            editNameController.text.toUpperCase().trim(),
            double.parse(amountController.text),
            double.parse(priceController.text),
            expireController.text);
        // editNameController.clear();
        // amountController.clear();
        // priceController.clear();
        // expireController.clear();
        showAwsomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Congrates!',
            desc: 'Edit Successsflly');
      } else {}
    } catch (e) {
      checkDebugMode(e);
    }
  }

  static deleteChemical(
      {required Box myBox,
      required String chemicalName,
      required BuildContext context}) {
    if (myBox.keys.contains(chemicalName.toUpperCase())) {
      ChemicalStorageHiveService.auth
          .deleteChemical(chemicalName.toUpperCase().trim());
      showAwsomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Delete',
          desc: 'The chemical deleted');
    } else {
      showAwsomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Please enter correct name of chemical');
    }
  }
}
