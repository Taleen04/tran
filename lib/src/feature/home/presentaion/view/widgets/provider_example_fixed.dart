// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // Example class to be provided
// class Example {
//   final String data;
  
//   Example({this.data = 'Hello from Example!'});
  
//   @override
//   String toString() => data;
// }

// // Fixed Provider example
// class ProviderExampleFixed extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // Fixed: Use Consumer to access the provided value
//       child: Consumer<Example>(
//         builder: (context, example, child) {
//           return Text(example.toString());
//         },
//       ),
//     );
//   }
// }

// // Alternative fix using Builder
// class ProviderExampleWithBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // Fixed: Use Builder to get the correct context
//       child: Builder(
//         builder: (context) {
//           return Text(context.watch<Example>().toString());
//         },
//       ),
//     );
//   }
// }

// // Alternative fix using Selector (most efficient)
// class ProviderExampleWithSelector extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // Fixed: Use Selector for better performance
//       child: Selector<Example, String>(
//         selector: (context, example) => example.toString(),
//         builder: (context, value, child) {
//           return Text(value);
//         },
//       ),
//     );
//   }
// }

// // Alternative fix by separating widgets
// class ProviderExampleSeparated extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       child: MyChildWidget(),
//     );
//   }
// }

// class MyChildWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Now this context has access to the Provider
//     return Text(context.watch<Example>().toString());
//   }
// }
