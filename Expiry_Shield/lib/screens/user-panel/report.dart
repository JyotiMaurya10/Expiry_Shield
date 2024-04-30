// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// class RadialChartExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Radial Chart Example'),
//       ),
//       body: Center(
//         child: Container(
//           height: 300,
//           child: SfRadialGauge(
//             axes: <RadialAxis>[
//               RadialAxis(
//                 minimum: 0,
//                 maximum: 100,
//                 ranges: <GaugeRange>[
//                   GaugeRange(startValue: 0, endValue: 40, color: Colors.green),
//                   GaugeRange(startValue: 40, endValue: 70, color: Colors.yellow),
//                   GaugeRange(startValue: 70, endValue: 100, color: Colors.red),
//                 ],
//                 pointers: <GaugePointer>[
//                   NeedlePointer(value: 65),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: RadialChartExample()));
