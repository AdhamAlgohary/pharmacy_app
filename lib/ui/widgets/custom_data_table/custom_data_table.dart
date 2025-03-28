import 'package:flutter/material.dart';
import 'package:pharmacy_app/model/chemical_model/chemical_model.dart';
import 'package:pharmacy_app/ui/screen/web_or_desktop_screen/chemical_screen/edit_chemical_screen/edit_chemical_screen.dart';
import 'package:pharmacy_app/ui/widgets/custom_txt/custom_txt.dart';
import 'package:pharmacy_app/utilits/constants/font_style.dart';
import 'package:pharmacy_app/utilits/screen_size/screen_size.dart';

// ignore: must_be_immutable
class CustomDataTable extends StatefulWidget {
  final int index;
  List<ChemicalModel> filteredList;
  final void Function()? deleteItemOnPressed;

  CustomDataTable(
      {Key? key,
      required this.index,
      required this.filteredList,
      this.deleteItemOnPressed})
      : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getwidth(context: context),
      child: DataTable(
        headingRowColor:
            const WidgetStatePropertyAll(Color.fromARGB(255, 105, 238, 240)),
        border: TableBorder.all(color: Colors.white),
        showBottomBorder: true,
        columns: <DataColumn>[
          DataColumn(
              label: CustomTxt(txt: 'Name of chemical', txtStyle: style4)),
          DataColumn(label: CustomTxt(txt: 'Kilos', txtStyle: style4)),
          DataColumn(label: CustomTxt(txt: 'Price of kilos', txtStyle: style4)),
          DataColumn(label: CustomTxt(txt: 'Expire date', txtStyle: style4)),
          DataColumn(label: CustomTxt(txt: 'Grams', txtStyle: style4)),
          DataColumn(label: CustomTxt(txt: 'Price of grams', txtStyle: style4)),
          DataColumn(
              label: Center(child: CustomTxt(txt: 'Edit', txtStyle: style4))),
          DataColumn(
              label: Center(child: CustomTxt(txt: 'Delete', txtStyle: style4))),
        ],
        rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(
              CustomTxt(
                txt: widget.filteredList[widget.index].nameOfChemical,
                txtStyle: style4,
              ),
            ),
            DataCell(
              CustomTxt(
                  txt: '${widget.filteredList[widget.index].kiloOfChemical}',
                  txtStyle: style4),
            ),
            DataCell(
              CustomTxt(
                  txt:
                      '${widget.filteredList[widget.index].priceOfKiloOfChemical}',
                  txtStyle: style4),
            ),
            DataCell(
              CustomTxt(
                  txt: widget.filteredList[widget.index].expireDateOfChemical
                      .toString()
                      .split(' ')[0],
                  txtStyle: style4),
            ),
            DataCell(
              CustomTxt(
                  txt: '${widget.filteredList[widget.index].gramsOfChemical}',
                  txtStyle: style4),
            ),
            DataCell(
              CustomTxt(
                  txt:
                      '${widget.filteredList[widget.index].priceOfgramsOfChemical}',
                  txtStyle: style4),
            ),
            DataCell(
              IconButton(
                alignment: Alignment.center,
                onPressed: () async {
                  ChemicalModel x = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditChemicalScreen(
                                chemicalName: widget
                                    .filteredList[widget.index].nameOfChemical,
                                chemicalAmount:
                                    '${widget.filteredList[widget.index].kiloOfChemical}',
                                chemicalPrice:
                                    '${widget.filteredList[widget.index].priceOfKiloOfChemical}',
                                chemicalExpire: widget
                                    .filteredList[widget.index]
                                    .expireDateOfChemical
                                    .toString()
                                    .split(' ')[0],
                              )));
                  setState(() {
                    widget.filteredList[widget.index] = x;
                  });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            DataCell(
              IconButton(
                alignment: Alignment.center,
                onPressed: widget.deleteItemOnPressed,
                icon: const Icon(Icons.delete),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
