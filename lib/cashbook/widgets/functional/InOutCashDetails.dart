import 'package:debts_app/cashbook/utility/dataClasses/CashbookModeldetails.dart';
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

    return Flex(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: [
        const Icon(
          Icons.arrow_upward_outlined,
          size: 25,
          color: Color(0xFF08A696),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              showDialog<bool>(
                context: context,
                builder: (context) {
                  final dialog = AlertDialog(
                      content: SizedBox(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWithDot(
                          text: 'Cash In',
                          style: TextStyle(color: Colors.blueGrey.shade200),
                        ),
                        const Divider(height: 3, color: Colors.white),
                        AppTextWithDot(
                          text: 'EGP ${totalCashIn}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ));
                  return dialog;
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: AppTextWithDot(
                    text: 'Cash in',
                    style: TextStyle(
                        color: Colors.blueGrey.shade200,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                AppTextWithDot(
                  text: 'EGP $totalCashIn',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.arrow_downward_outlined,
          size: 25,
          color: const Color(0xFFF88D93),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              showDialog<bool>(
                context: context,
                builder: (context) {
                  final dialog = AlertDialog(
                      content: SizedBox(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWithDot(
                          text: 'Cash Out',
                          style: TextStyle(color: Colors.blueGrey.shade200),
                        ),
                        const Divider(height: 3, color: Colors.white),
                        AppTextWithDot(
                          text: 'EGP ${totalCashOut}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ));
                  return dialog;
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: AppTextWithDot(
                    text: 'Cash out',
                    style: TextStyle(
                        color: Colors.blueGrey.shade200,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                AppTextWithDot(
                  text: 'EGP $totalCashOut',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
