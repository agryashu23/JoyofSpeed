import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  List<String> statusList = [];
  final int currentStatusIndex;

  OrderStatusTimeline({
    Key? key,
    required this.statusList,
    required this.currentStatusIndex,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statusList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              _buildStatusBubble(index),
              if (index != statusList.length - 1) _buildStatusLine(index),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusBubble(int index) {
    final isCompleted = index < currentStatusIndex;
    final isCurrent = index == currentStatusIndex;
    final color = isCompleted ? Colors.green : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent ? Colors.blue : color,
        border: Border.all(color: Colors.black),
      ),
      width: 30.0,
      height: 30.0,
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: isCurrent ? Colors.white : Colors.black,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLine(int index) {
    return Expanded(
      child: Container(
        height: 1.0,
        color: index < currentStatusIndex ? Colors.green : Colors.grey,
      ),
    );
  }
}
