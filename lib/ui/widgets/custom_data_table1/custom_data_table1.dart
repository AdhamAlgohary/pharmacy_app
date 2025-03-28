import 'package:flutter/material.dart';

class CustomDataTable1 extends StatefulWidget {
  final Widget label1;
  final Widget label2;
  final Widget label3;
  final Widget label5;
  final Widget label4;

  final Widget dataCell1;
  final Widget dataCell2;
  final Widget dataCell3;
  final Widget dataCell4;

  final Widget dataCell5;

  final void Function()? function;
  const CustomDataTable1(
      {Key? key,
      required this.label1,
      required this.dataCell1,
      required this.label2,
      required this.dataCell2,
      required this.label3,
      required this.dataCell3,
      this.function,
      required this.label4,
      required this.dataCell4,
      required this.label5,
      required this.dataCell5})
      : super(key: key);

  @override
  State<CustomDataTable1> createState() => _CustomDataTable1State();
}

class _CustomDataTable1State extends State<CustomDataTable1> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 105, 238, 240)),
      border: TableBorder.all(color: Colors.white),
      showBottomBorder: true,
      columns: [
        DataColumn(label: widget.label1),
        DataColumn(label: widget.label2),
        DataColumn(label: widget.label3),
        DataColumn(label: widget.label4),
        DataColumn(label: widget.label5),
      ],
      rows: <DataRow>[
        DataRow(cells: <DataCell>[
          DataCell(widget.dataCell1,
              showEditIcon: false, onTap: widget.function),
          DataCell(widget.dataCell2),
          DataCell(widget.dataCell3),
          DataCell(widget.dataCell4),
          DataCell(widget.dataCell5),
        ])
      ],
    );
  }
}
