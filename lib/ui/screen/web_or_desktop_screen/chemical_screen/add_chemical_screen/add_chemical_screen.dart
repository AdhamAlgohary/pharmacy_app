
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/chemical_screen/component/custom_column/custom_column.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/component/back_ground_container.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/functions/chemical_functions/chemical_functions.dart';
import 'package:pharmacy_app/utilits/screen_size/screen_size.dart';

class AddChemicalScreen extends StatefulWidget {
  const AddChemicalScreen({Key? key}) : super(key: key);

  @override
  State<AddChemicalScreen> createState() => _AddChemicalScreenState();
}

class _AddChemicalScreenState extends State<AddChemicalScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController expireController = TextEditingController();
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> amountKey = GlobalKey<FormState>();
  GlobalKey<FormState> priceKey = GlobalKey<FormState>();
  GlobalKey<FormState> expireKey = GlobalKey<FormState>();
  Box myBox = Hive.box<ChemicalModel>('chemicalinfo');
  // String expire = null.toString();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    priceController.dispose();
    expireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightBlue[100],
          title:  Text(
            'Chemical',
            style: style1.copyWith(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: () {
            ChemiclaFunctions.addChemical(
              context: context,
              amountKey: amountKey,
              expireController: expireController,
              priceKey: priceKey,
              nameKey: nameKey,
              myBox: myBox,
              nameController: nameController,
              amountController: amountController,
              priceController: priceController,
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        body: Stack(
          children: [
            const BackGroundContainr(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.6 * getHeight(context: context)),
              child: CustomColumn(
                amountController: amountController,
                amountKey: amountKey,
                nameController: nameController,
                nameKey: nameKey,
                priceController: priceController,
                priceKey: priceKey,
                expireController: expireController,
                function: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2100))
                    .then((value) {
                     
                  setState(() {
                    expireController.text = value.toString().split(' ')[0];
                    
                  });
                }),
              ),
            ),
          ],
        ));
  }
}
