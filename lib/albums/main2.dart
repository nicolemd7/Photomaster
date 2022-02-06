import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photomaster/albums/pick_home_page.dart';
import 'package:photomaster/albums/photo_provider.dart';
import 'package:photomaster/Widgets/asset_path_widget.dart';
import 'package:photomaster/Widgets/current_path_selector.dart';
import 'package:photomaster/Widgets/pick/pick_asset_widget.dart';
import 'package:photomaster/Widgets/pick/pick_sure_button.dart';

//void main() => runApp(MyApp());

class Main2 extends StatefulWidget {
  static const String id = "Main2_screen";

  @override
  _Main2State createState() => _Main2State();
}

class _Main2State extends State<Main2> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      backgroundColor: Colors.blue,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// class main2 extends StatefulWidget {
//   static const String id = "main2_screen";
//   @override
//   _main2State createState() => _main2State();
// }

// class MyApp extends State<Main2> {
//   @override
//   Widget build(BuildContext context) {
//     return OKToast(
//       backgroundColor: Colors.blue,
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: MyHomePage(title: 'Flutter Demo Home Page'),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const debugPage = true;

class _MyHomePageState extends State<MyHomePage> {
  final provider = PickerDataProvider();

  @override
  void initState() {
    super.initState();
    provider.max = 3;
    provider.onPickMax.addListener(onPickMax);
  }

  void onPickMax() {
    showToast("Already pick ${provider.max} items.");
  }

  @override
  void dispose() {
    provider.onPickMax.removeListener(onPickMax);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (debugPage) {
      return PhotoPickHomePage(
        provider: provider,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple example"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: _refreshGalleryList,
            child: Text('refresh gallery list'),
          ),
          _buildDropdownButton(),
          AnimatedBuilder(
            animation: provider.currentPathNotifier,
            builder: (_, __) => Expanded(child: _buildPath()),
          ),
        ],
      ),
    );
  }

  void _refreshGalleryList() async {
    final pathList = await PhotoManager.getAssetPathList();
    provider.resetPathList(pathList, sortBy: (a, b) {
      if (a.isAll) {
        return -1;
      }
      if (b.isAll) {
        return 1;
      }
      return 0;
    });
  }

  Widget _buildDropdownButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SelectedPathDropdownButton(
          provider: provider,
        ),
        PickSureButton(
          provider: provider,
        ),
      ],
    );
  }

  Widget _buildPath() {
    if (provider.currentPath == null) {
      return Container();
    }
    return AssetPathWidget(
      path: provider.currentPath,
      buildItem: (context, asset, size) {
        return PickAssetWidget(
          asset: asset,
          provider: provider,
          thumbSize: size,
        );
        // return AssetWidget(asset: asset);
      },
    );
  }
}
