import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/chemical_screen/edit_chemical_screen/edit_chemical_screen.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/component/back_ground_container.dart';
import 'package:pharmacy_app/ui/widgets/custom_data_table/custom_data_table.dart';
import 'package:pharmacy_app/ui/widgets/custom_search_delegate/custom_search_delegate.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/functions/chemical_functions/chemical_functions.dart';

class ViewChemicalScreen extends StatefulWidget {
  const ViewChemicalScreen({Key? key}) : super(key: key);

  @override
  State<ViewChemicalScreen> createState() => _ViewChemicalScreenState();
}

class _ViewChemicalScreenState extends State<ViewChemicalScreen> {
  late Box myBox;
  late List<ChemicalModel> filteredList;
  @override
  void initState() {
    myBox = Hive.box<ChemicalModel>('chemicalinfo');
    filteredList = myBox.values.toList() as List<ChemicalModel>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        centerTitle: true,
        title: CustomTxt(
          txt: 'My Chemical',
          txtStyle: style1.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(
                        baseList: Hive.box<ChemicalModel>('chemicalinfo')
                            .values
                            .toList(),
                        name: 'nameOfChemical',
                        flag: 0));
              })
        ],
      ),
      body: Stack(
        children: [
          const BackGroundContainr(),
          ListView.builder(
            itemCount: myBox.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: width,
                height: 0.14 * height,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      CustomDataTable(
                        index: index,
                        filteredList: filteredList,
                        deleteItemOnPressed: () => {
                          ChemiclaFunctions.deleteChemical(
                              myBox: myBox,
                              chemicalName:
                                  myBox.values.toList()[index].nameOfChemical,
                              context: context),
                          setState(() {})
                        },
                      ),
                    ]),
              );
            },
          ),
        ],
      ),
    );
  }
}
