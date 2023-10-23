import 'package:flutter/material.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class MDataText extends StatelessWidget {
  const MDataText({
    Key? key,
    required this.rows,
    this.dataSpace = 20,
    this.lineSpace = 10,
    this.fontSize = 14,
    this.labelFontWeight,
    this.valueFontWeight,
    this.valueColors,
    this.valueWidth = 400,
    this.valueSuffix,
    this.color,
    this.seperator,
    this.enableDoubleLine = false,
  }) : super(key: key);

  final List<_MRow> rows;
  final double dataSpace;
  final double lineSpace;
  final double fontSize;
  final FontWeight? labelFontWeight;
  final FontWeight? valueFontWeight;
  final Map<int, Color>? valueColors;
  final Map<int, Widget>? valueSuffix;
  final double valueWidth;
  final Color? color;
  final bool enableDoubleLine;
  final String? seperator;

  @override
  Widget build(BuildContext context) {
    return enableDoubleLine ? _buildDoubleLine() : _buildSingleLine();
  }

  Widget _buildSingleLine() {
    return Table(
      columnWidths: {
        0: const IntrinsicColumnWidth(),
        1: FixedColumnWidth(dataSpace),
        2: const FlexColumnWidth(),
      },
      // border: TableBorder.all(color: Colors.black),
      children: List.generate(rows.where((element) => element.visible).length,
          (index) {
        final _MRow row =
            rows.where((element) => element.visible).toList()[index];
        if (row.isDivider) {
          return TableRow(
            children: [
              Divider(
                color: row.color,
              ),
              Divider(
                color: row.color,
              ),
              Divider(
                color: row.color,
              ),
            ],
          );
        }
        return TableRow(
          children: [
            // label text
            _buildLabelText(row),
            Center(
              child: Column(
                children: [
                  MText(
                    text: seperator ?? ':',
                    fontSize: fontSize,
                    fontWeight: labelFontWeight,
                    color: color,
                  ),
                  MSpace.vertical(lineSpace)
                ],
              ),
            ),
            // value text

            if (row.suffix != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: _buildValueText(row)),
                  MSpace.horizonital(20),
                  SizedBox(
                    child: row.suffix,
                  )
                ],
              )
            else
              _buildValueText(row),
          ],
        );
      }),
    );
  }

  Widget _buildDoubleLine() {
    final visibleList = rows.where((element) => element.visible).toList();
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(visibleList.length, (index) {
          final row = visibleList[index];
          return Padding(
            padding:const  EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabelText(row),
                if (row.suffix != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: _buildValueText(row)),
                      MSpace.horizonital(20),
                      SizedBox(
                        child: row.suffix,
                      )
                    ],
                  )
                else
                  _buildValueText(row),
              ],
            ),
          );
        }),
      ),
    );
  }

  MText _buildLabelText(_MRow row) {
    return MText(
      text: '${row.label} ',
      fontSize: fontSize,
      fontWeight: labelFontWeight,
      color: color,
    );
  }

  MText _buildValueText(_MRow row) {
    return MText(
      text: '${row.value}',
      fontSize: fontSize,
      fontWeight: valueFontWeight,
      color: row.color ?? color,
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
    );
  }
}

class _MRow {
  final String? label;
  final String? value;
  final Color? color;
  final Widget? suffix;
  final bool visible;
  final bool isDivider;

  _MRow({
    this.label,
    this.value,
    this.visible = true,
    this.isDivider = false,
    this.color,
    this.suffix,
  });
}

class MDataTextRow extends _MRow {
  MDataTextRow({
    required String label,
    required String value,
    Color? color,
    Widget? suffix,
    bool visible = true,
  }) : super(
          label: label,
          value: value,
          color: color,
          suffix: suffix,
          visible: visible,
          isDivider: false,
        );
}

class MDataTextDivider extends _MRow {
  MDataTextDivider({Color? color, bool? visible})
      : super(
          color: color,
          isDivider: true,
          visible: visible ?? true,
        );
}
