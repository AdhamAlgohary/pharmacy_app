import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/component/back_ground_container.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/chemical_screen/component/custom_column/custom_column.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/functions/chemical_functions/chemical_functions.dart';
import 'package:pharmacy_app/utilits/screen_size/screen_size.dart';

class EditChemicalScreen extends StatefulWidget {
  const EditChemicalScreen(
      {Key? key,
      required this.chemicalName,
      required this.chemicalAmount,
      required this.chemicalPrice,
      required this.chemicalExpire})
      : super(key: key);
  final String chemicalName;
  final String chemicalAmount;
  final String chemicalPrice;
  final String chemicalExpire;

  @override
  State<EditChemicalScreen> createState() => _EditChemicalScreenState();
}

class _EditChemicalScreenState extends State<EditChemicalScreen> {
  late final TextEditingController amountController;
  late final TextEditingController priceController;
  late final TextEditingController editNameController;
  late final TextEditingController expireController;

  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> amountKey = GlobalKey<FormState>();
  GlobalKey<FormState> priceKey = GlobalKey<FormState>();
  bool isEdit = false;
  Box myBox = Hive.box<ChemicalModel>('chemicalinfo');
  // String expire = null.toString();
  @override
  void initState() {
    amountController = TextEditingController(text: widget.chemicalAmount);
    priceController = TextEditingController(text: widget.chemicalPrice);
    expireController = TextEditingController(text: widget.chemicalExpire);
    editNameController = TextEditingController(
      text: widget.chemicalName,
    );
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    priceController.dispose();
    editNameController.dispose();
    expireController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ChemiclaFunctions.edit(
              context: context,
              amountKey: amountKey,
              priceKey: priceKey,
              editNameController: editNameController,
              chemicalOldName: widget.chemicalName.toUpperCase().trim(),
              amountController: amountController,
              priceController: priceController,
              expireController: expireController);
          isEdit = true;
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
        title: CustomTxt(
            txt: 'Edit Chemical',
            txtStyle: style1.copyWith(color: Colors.white)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  ChemicalModel(
                    nameOfChemical:
                        editNameController.text.toUpperCase().trim(),
                    kiloOfChemical: double.parse(amountController.text),
                    priceOfKiloOfChemical: double.parse(priceController.text),
                    expireDateOfChemical:
                        expireController.text.toUpperCase().trim(),
                    priceOfgramsOfChemical:
                        double.parse(priceController.text) / 1000,
                    gramsOfChemical: double.parse(amountController.text) * 1000,
                  ));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          const BackGroundContainr(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.6 * getHeight(context: context)),
            child: ListView(
                padding:
                    EdgeInsets.only(top: 0.05 * getHeight(context: context)),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 0.8 * getHeight(context: context),
                    child: CustomColumn(
                      nameController: editNameController,
                      amountController: amountController,
                      priceController: priceController,
                      expireController: expireController,
                      nameKey: nameKey,
                      amountKey: amountKey,
                      priceKey: priceKey,
                      function: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2100))
                          .then((value) {
                        setState(() {
                          expireController.text =
                              value.toString().split(' ')[0];
                        });
                      }),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
