import 'package:debts_app/cashbook/utility/Utility.dart';
import 'package:debts_app/cashbook/utility/dataClasses/CashbookModelDetails.dart';
import 'package:debts_app/cashbook/widgets/partial/AppTextWithDots.dart';
import 'package:flutter/material.dart';

class InOutCashDetails extends StatelessWidget {
  const InOutCashDetails({required this.models, Key? key}) : super(key: key);
  final CashBookModelListDetails models;

  @override
  Widget build(BuildContext context) {
    //getting the latest row in the table to get the recent info.
    final double totalCashIn = models.totalCashIn;
    final double totalCashOut = models.totalCashOut;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            showDialog<bool>(
              context: context,
              builder: (context) {
                final dialog = AlertDialog(
                    content: Container(
                  constraints: const BoxConstraints(minWidth: 1, maxWidth: 150),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWithDot(
                        text: 'Cash In',
                        style: TextStyle(color: Colors.blueGrey.shade200),
                      ),
                      const Divider(height: 3, color: Colors.white),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: 'EGP',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                        TextSpan(
                            text: ' ${Utility.formatCashNumber(totalCashIn)}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))
                      ]))
                    ],
                  ),
                ));
                return dialog;
              },
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_upward_outlined,
                size: 25,
                color: Color(0xFF08A696),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AppTextWithDot(
                      text: 'Cash in',
                      style: TextStyle(
                          color: Colors.blueGrey.shade200,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 1, maxWidth: 150),
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'EGP',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 9)),
                      TextSpan(
                          text: ' ${Utility.formatCashNumber(totalCashIn)}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ])),
                  )
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showDialog<bool>(
              context: context,
              builder: (context) {
                final dialog = AlertDialog(
                    content: Container(
                  constraints: const BoxConstraints(minWidth: 1, maxWidth: 150),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWithDot(
                        text: 'Cash Out',
                        style: TextStyle(color: Colors.blueGrey.shade200),
                      ),
                      const Divider(height: 3, color: Colors.white),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: 'EGP',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                        TextSpan(
                            text:
                                ' ${Utility.formatCashNumber(totalCashOut.abs())}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))
                      ]))
                    ],
                  ),
                ));
                return dialog;
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.arrow_downward_outlined,
                size: 25,
                color: Color(0xFFF88D93),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AppTextWithDot(
                      text: 'Cash out',
                      style: TextStyle(
                          color: Colors.blueGrey.shade200,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 1, maxWidth: 150),
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'EGP',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 9)),
                      TextSpan(
                          text:
                              ' ${Utility.formatCashNumber(totalCashOut.abs())}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ])),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
