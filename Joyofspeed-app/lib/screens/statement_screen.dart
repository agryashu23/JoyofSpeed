import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joy_of_speed/components/file_handle_api.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Statement {
  static Future<File> generate() async {
    final pdf = pw.Document();

    final iconImage =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    DateTime date = DateTime.now();

    var date2 = DateTime(date.year, date.month + 1, date.day);
    String next_month = DateFormat("MMMM").format(date2);

    String now = DateFormat("dd-MM-yyyy").format(date);
    String now2 = DateFormat("MMMM").format(date);

    final data = ["Yashu Agrawal", "6232446830", "agryashu23@gmail.com"];

    final tableHeaders = [
      'Description',
      'Date',
      'Debit',
      'Credit',
      'Available'
    ];

    final tableData = [
      [
        'Track No. #7847NDBD',
        '30-03-2023',
        '0',
        '500',
        '500',
      ],
      [
        'Track No. #8390MDHFJ',
        '31-03-2023',
        '200',
        '0',
        '300',
      ],
      [
        'Track No. #7847NDBD',
        '30-03-2023',
        '0',
        '500',
        '800',
      ],
      [
        'Track No. #8390MDHFJ',
        '31-03-2023',
        '200',
        '0',
        '600',
      ],
      [
        'Track No. #7847NDBD',
        '30-03-2023',
        '0',
        '500',
        '1100',
      ],
      [
        'Track No. #8390MDHFJ',
        '31-03-2023',
        '200',
        '0',
        '900',
      ],
      [
        'Track No. #7847NDBD',
        '30-03-2023',
        '0',
        '500',
        '1400',
      ],
      [
        'Track No. #8390MDHFJ',
        '31-03-2023',
        '200',
        '0',
        '1200',
      ],
      [
        'Track No. #7847NDBD',
        '30-03-2023',
        '0',
        '500',
        '1700',
      ],
      [
        'Track No. #8390MDHFJ',
        '31-03-2023',
        '200',
        '0',
        '1500',
      ],
    ];

    pdf.addPage(
      pw.MultiPage(
        header: (context) {
          return pw.Column(children: [
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
                      'STATEMENT',
                      style: pw.TextStyle(
                        fontSize: 17.w,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Joyofspeed',
                      style: pw.TextStyle(
                        fontSize: 15.w,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Text(
                  "From:  ${now2} - ${next_month}",
                  style: pw.TextStyle(
                      fontSize: 17.w,
                      lineSpacing: 1.2,
                      fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.justify,
                ),
              ],
            ),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 3 * PdfPageFormat.mm),
          ]);
        },
        build: (context) {
          return [
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                        text:
                            "From - \nJoyofSpeed\n7470899521\nsameer@joyofspeed.in",
                        style: pw.TextStyle(
                          fontSize: 15.w,
                          lineSpacing: 1.5,
                        ),
                        children: [
                          pw.TextSpan(
                            text: "\nGST No.- NHFUH7Y44R8R89R",
                            style:
                                pw.TextStyle(fontSize: 14.w, lineSpacing: 1.5),
                          )
                        ]),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                        text: "To - \n${data[0]}\n${data[1]}\n${data[2]}",
                        style: pw.TextStyle(
                          fontSize: 15.w,
                          lineSpacing: 1.5,
                        ),
                        children: [
                          pw.TextSpan(
                            text: "\nGST No.-" + "DVBJVBJ4849J98",
                            style:
                                pw.TextStyle(fontSize: 14.w, lineSpacing: 1.5),
                          )
                        ]),
                  ),
                ]),

            pw.SizedBox(height: 7 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14.w),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 40.0,
              cellStyle: pw.TextStyle(fontSize: 13.w),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 7 * PdfPageFormat.mm),

            pw.Text(
              "STATEMENT SUMMARY:-",
              style: pw.TextStyle(
                  fontSize: 19.w,
                  lineSpacing: 1.2,
                  fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 7 * PdfPageFormat.mm),

            pw.Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pw.Column(children: [
                  pw.Text(
                    'Transactions-',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16.w),
                  ),
                  pw.Text(
                    '10',
                    style: pw.TextStyle(fontSize: 16.w),
                  ),
                ]),
                pw.Column(
                  children: [
                    pw.Text(
                      'Credits-',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16.w),
                    ),
                    pw.Text(
                      '2500',
                      style: pw.TextStyle(fontSize: 16.w),
                    ),

                    // pw.SizedBox(height: 2 * PdfPageFormat.mm),
                    // pw.Container(height: 1, color: PdfColors.grey400),
                    // pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                    // pw.Container(height: 1, color: PdfColors.grey400),
                  ],
                ),
                pw.Column(children: [
                  pw.Text(
                    'Debits-',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16.w),
                  ),
                  pw.Text(
                    '1000',
                    style: pw.TextStyle(fontSize: 16.w),
                  ),
                ]),
                pw.Column(children: [
                  pw.Text(
                    'Closing Bal.-',
                    style: pw.TextStyle(
                      fontSize: 16.w,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '1500',
                    style: pw.TextStyle(
                      fontSize: 16.w,
                    ),
                  ),
                ]),
              ],
            ),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),

            pw.Center(
              child: pw.RichText(
                text: pw.TextSpan(
                    text: "Generated On- ",
                    style: pw.TextStyle(
                        fontSize: 16.w, fontWeight: FontWeight.bold),
                    children: [
                      pw.TextSpan(
                        text: now,
                        style: pw.TextStyle(
                          fontSize: 14.w,
                          lineSpacing: 1.5,
                        ),
                      )
                    ]),
              ),
            ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            pw.Text(
              'This is a Computer generated statement and does not require signature',
              style: pw.TextStyle(fontSize: 14.w),
            ),
          ];
        },
        footer: (pw.Context context) {
          return context.pageNumber == context.pagesCount
              ? pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Divider(),
                    pw.SizedBox(height: 2 * PdfPageFormat.mm),
                    pw.Text(
                      'Joyofspeed',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15.w),
                    ),
                    pw.SizedBox(height: 1 * PdfPageFormat.mm),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Address: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15.w),
                        ),
                        pw.Text(
                          'B34/154 A-Z-4A, Sarainandan, Sunderpur, \n Varanasi - 221010, Uttar Pradesh, India',
                          style: pw.TextStyle(fontSize: 14.w),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 1 * PdfPageFormat.mm),
                  ],
                )
              : Container();
        },
      ),
    );

    return FileHandleApi.saveDocument(name: '${now2}_statement', pdf: pdf);
  }
}
