import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quotemytrade/core/models/estimation.dart';

class PdfService {
  Future<void> generateAndSharePdf(
    Estimation estimation, {
    bool share = false,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          pw.Text(
            "QuoteMyTrade",
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Professional Cost Estimate",
            style: const pw.TextStyle(fontSize: 20),
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            "Estimated Total Cost: Rs.${estimation.totalCost.toStringAsFixed(0)} (±5%)",
            style: const pw.TextStyle(fontSize: 18),
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            "Detailed Line Items",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              'Category & Description',
              'Qty',
              'Unit Cost',
              'Total Cost',
            ],
            data: estimation.items
                .map(
                  (item) => [
                    "${item.category}: ${item.description}",
                    item.quantity.toStringAsFixed(0),
                    "Rs.${item.unitCost.toStringAsFixed(2)}",
                    "Rs.${item.totalCost.toStringAsFixed(2)}",
                  ],
                )
                .toList(),
            border: null,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            "Assumptions",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...estimation.assumptions.map(
            (a) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text("- $a"),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Cost-Saving Suggestions",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...estimation.suggestions.map(
            (s) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text("* $s"),
            ),
          ),
          pw.SizedBox(height: 40),
          pw.Text(
            "Generated on ${DateTime.now().toString().substring(0, 10)}",
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();

    if (share) {
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'quotemytrade_estimate.pdf',
      );
    } else {
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    }
  }
}
