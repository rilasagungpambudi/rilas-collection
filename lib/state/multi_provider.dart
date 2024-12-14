import 'package:bookcolection/state/book_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> multiProvider = [
  ChangeNotifierProvider(create: (_) => ProviderBook()),
];
