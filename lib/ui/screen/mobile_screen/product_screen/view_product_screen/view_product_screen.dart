import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy_app/model/product_model/product_model.dart';
import 'package:pharmacy_app/ui/screen/mobile_screen/chemicals_in_products_screen/chemicals_in_product_screen.dart';
import 'package:pharmacy_app/ui/widgets/custom_data_table1/custom_data_table1.dart';
import 'package:pharmacy_app/ui/widgets/custom_search_delegate/custom_search_delegate.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/view-model/product_view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({Key? key}) : super(key: key);

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  late Box myBox;
  @override
  void initState() {
    myBox = Hive.box<ProductModel>('productinfo');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1 * height),
        child: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                          baseList: Hive.box<ProductModel>('productinfo')
                              .values
                              .toList(),
                          name: 'nameOfProduct', flag: 1));
                })
          ],
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
          title: CustomTxt(
            txt: 'Show Product',
            txtStyle: style1,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return SizedBox(
            height: 0.17 * height,
            width: width,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                CustomDataTable1(
                  function: () {
                    Provider.of<ProductViewModel>(context, listen: false)
                        .nameOfProduct = myBox.getAt(index).nameOfProduct;
                    Provider.of<ProductViewModel>(context, listen: false)
                        .priceOfProduct = myBox.getAt(index).priceOfProduct;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>const ChemicalsInProduct()));
                  },
                  label1: CustomTxt(
                    txt: 'nameOfProduct',
                    txtStyle: style4,
                  ),
                  dataCell1: CustomTxt(
                      txt: '${myBox.getAt(index).nameOfProduct}',
                      txtStyle: style4),
                  label2: CustomTxt(
                      txt: 'priceOfProduct', txtStyle: style4),
                  dataCell2: CustomTxt(
                      txt: '${myBox.getAt(index).priceOfProduct}',
                      txtStyle: style4),
                  label3: CustomTxt(
                    txt: 'expireDateOFProduct',
                    txtStyle: style4,
                  ),
                  dataCell3: CustomTxt(
                      txt: '${myBox.getAt(index).expireDateOfProduct}',
                      txtStyle: style4),
                  label4: CustomTxt(txt: 'Edit', txtStyle: style4), 
                  dataCell4: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit)),
                  label5: CustomTxt(txt: 'Delete', txtStyle: style4),
                  dataCell5: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete))
                ),
              ],
            ),
          );
        },
        itemCount: context.watch<ProductViewModel>().myBox1.length,
      ),
    );
  }
}
