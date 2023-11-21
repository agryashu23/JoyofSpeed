import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate(dynamic data,dynamic tableData,dynamic total,dynamic discount) async {
    final pdf = pw.Document();

    final iconImage =
    (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());



    final tableHeaders = [
      'Description',
      'Discount',
      'Total',
    ];


    pdf.addPage(
      pw.MultiPage(
        // header: (context) {
        //   return pw.Text(
        //     'Flutter Approach',
        //     style: pw.TextStyle(
        //       fontWeight: pw.FontWeight.bold,
        //       fontSize: 15.0,
        //     ),
        //   );
        // },
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 85.h,
                  width: 72.w,
                ),
                pw.SizedBox(width: 2 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 17.w,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Joyofspeed',
                      style:  pw.TextStyle(
                        fontSize: 15.w,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "GST No.-"+"EFNEH7Y44R9R4JO0",
                      style:  pw.TextStyle(
                      fontSize: 13.w,
                      ),
                    ),
                    pw.Text(
                      now,
                      style:  pw.TextStyle(
                        fontSize: 14.w,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 3 * PdfPageFormat.mm),
            pw.Text(
              "To - \n${data[0]}\n${data[1]}\n${data[2]}",
              style:  pw.TextStyle(
                fontSize: 15.w,
                lineSpacing: 1.2
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 7 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15.w),
              headerDecoration:
              const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 40.0,
              cellStyle: pw.TextStyle(fontSize: 15.w),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Net total-',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16.w
                                ),
                              ),
                            ),
                            pw.Text(
                              'Rs. ${total}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                  fontSize: 16.w

                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 1 * PdfPageFormat.mm),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Discount-',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                    fontSize: 16.w

                                ),
                              ),
                            ),
                            pw.Text(
                              'Rs. ${discount}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                  fontSize: 16.w

                              ),
                            ),
                          ],
                        ),
                        pw.Divider(),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Amount Paid-',
                                style: pw.TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: pw.FontWeight.bold,

                                ),
                              ),
                            ),
                            pw.Text(
                                      'Rs. 300',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16.w,

                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'Joyofspeed',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15.w),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Address: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15.w),
                  ),
                  pw.Text(
                    'B34/154 A-Z-4A, Sarainandan, Sunderpur, \n Varanasi - 221010, Uttar Pradesh, India',
                    style: pw.TextStyle(fontSize: 14.w),

                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Email: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15.w),
                  ),
                  pw.Text(
                    'sameer@joyofspeed.in',
                    style: pw.TextStyle(fontSize: 15.w),

                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: '${now}_invoice.pdf', pdf: pdf);
  }
}