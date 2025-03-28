import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/product_screen/edit_product_screen/edit_product_screen.dart';
import 'package:pharmacy_app/ui/widgets/custom_data_table/custom_data_table.dart';
import 'package:pharmacy_app/ui/widgets/custom_data_table1/custom_data_table1.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/functions/product_functions/product_functions.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List baseList;
  final String name;
  final int flag;
  final Box? myBox;
  CustomSearchDelegate(
      {required this.flag,
      required this.name,
       this.myBox,
      required this.baseList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List values = baseList;
    List filterNames = flag == 0
        ? values
            .where((element) =>
                element.nameOfChemical.contains(query.toUpperCase()))
            .toList()
        : values
            .where((element) =>
                element.nameOfProduct.contains(query.toUpperCase()))
            .toList();
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: ListView.builder(
          itemCount: query == '' ? values.length : filterNames.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
                width: width,
                height: 0.17 * height,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    flag == 0
                        ? CustomDataTable(
                            index: index,
                            filteredList: filterNames as List<ChemicalModel>,
                          )
                        : CustomDataTable1(
                            label1: CustomTxt(
                                txt: 'Name of product', txtStyle: style4),
                            dataCell1: CustomTxt(
                                txt: '${filterNames[index].nameOfProduct}',
                                txtStyle: style4),
                            label2: CustomTxt(
                                txt: 'Price of product', txtStyle: style4),
                            dataCell2: CustomTxt(
                                txt: '${filterNames[index].priceOfProduct}',
                                txtStyle: style4),
                            label3: CustomTxt(
                                txt: 'Expire date of product',
                                txtStyle: style4),
                            dataCell3: CustomTxt(
                                txt:
                                    '${filterNames[index].expireDateOfProduct}',
                                txtStyle: style4),
                            label4: CustomTxt(txt: 'Edit', txtStyle: style4),
                            dataCell4: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const EditProducScreen()));
                                },
                                icon: const Icon(Icons.edit)),
                            label5: CustomTxt(txt: 'Delete', txtStyle: style4),
                            dataCell5: IconButton(
                                onPressed: () {
                                  ProductFunctions.deleteProduct(
                                      context: context,
                                      deletedProduct:
                                          myBox?.getAt(index).nameOfProduct);
                                },
                                icon: const Icon(Icons.delete)))
                  ],
                ));
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List values = baseList;
    List filterNames = flag == 0
        ? values
            .where((element) =>
                element.nameOfChemical.contains(query.toUpperCase()))
            .toList()
        : values
            .where((element) =>
                element.nameOfProduct.contains(query.toUpperCase()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: ListView.builder(
          itemCount: query == '' ? values.length : filterNames.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
                width: width,
                height: 0.17 * height,
                child: query == ''
                    ? ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          flag == 0
                              ? CustomDataTable(
                                  index: index,
                                  filteredList: values as List<ChemicalModel>,
                                )
                              : CustomDataTable1(
                                  label1: CustomTxt(
                                      txt: 'nameOfProduct', txtStyle: style4),
                                  dataCell1: CustomTxt(
                                      txt: '${values[index].nameOfProduct}',
                                      txtStyle: style4),
                                  label2: CustomTxt(
                                      txt: 'priceOfProduct', txtStyle: style4),
                                  dataCell2: CustomTxt(
                                      txt: '${values[index].priceOfProduct}',
                                      txtStyle: style4),
                                  label3: CustomTxt(
                                      txt: 'expireDateOfProduct',
                                      txtStyle: style4),
                                  dataCell3: CustomTxt(
                                      txt:
                                          '${values[index].expireDateOfProduct}',
                                      txtStyle: style4),
                                  label4:
                                      CustomTxt(txt: 'Edit', txtStyle: style4),
                                  dataCell4: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const EditProducScreen()));
                                      },
                                      icon: const Icon(Icons.edit)),
                                  label5: CustomTxt(
                                      txt: 'Delete', txtStyle: style4),
                                  dataCell5: IconButton(
                                      onPressed: () {
                                        ProductFunctions.deleteProduct(
                                            context: context,
                                            deletedProduct: myBox?.getAt(index).nameOfProduct);
                                      },
                                      icon: const Icon(Icons.delete))),
                        ],
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          flag == 0
                              ? CustomDataTable(
                                  index: index,
                                  filteredList:
                                      filterNames as List<ChemicalModel>,
                                )
                              : CustomDataTable1(
                                  label1: CustomTxt(
                                      txt: 'nameOfProduct', txtStyle: style4),
                                  dataCell1: CustomTxt(
                                      txt:
                                          '${filterNames[index].nameOfProduct}',
                                      txtStyle: style4),
                                  label2: CustomTxt(
                                      txt: 'priceOfProduct', txtStyle: style4),
                                  dataCell2: CustomTxt(
                                      txt:
                                          '${filterNames[index].priceOfProduct}',
                                      txtStyle: style4),
                                  label3: CustomTxt(
                                      txt: 'expireDateOfProduct',
                                      txtStyle: style4),
                                  dataCell3: CustomTxt(
                                      txt:
                                          '${filterNames[index].expireDateOfProduct}',
                                      txtStyle: style4),
                                  label4:
                                      CustomTxt(txt: 'Edit', txtStyle: style4),
                                  dataCell4: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const EditProducScreen()));
                                      },
                                      icon: const Icon(Icons.edit)),
                                  label5: CustomTxt(
                                      txt: 'Delete', txtStyle: style4),
                                  dataCell5: IconButton(
                                      onPressed: () {
                                        ProductFunctions.deleteProduct(
                                            context: context,
                                            deletedProduct: myBox?.getAt(index).nameOfProduct);
                                      },
                                      icon: const Icon(Icons.delete)),
                                ),
                        ],
                      ));
          }),
    );
  }
}
