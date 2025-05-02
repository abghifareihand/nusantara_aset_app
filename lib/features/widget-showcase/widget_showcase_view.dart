import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/widget-showcase/widget_showcase_view_model.dart';

class WidgetShowcaseView extends StatelessWidget {
  const WidgetShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<WidgetShowcaseViewModel>(
      model: WidgetShowcaseViewModel(),
      onModelReady: (WidgetShowcaseViewModel model) => model.initModel(),
      onModelDispose: (WidgetShowcaseViewModel model) => model.disposeModel(),
      builder: (BuildContext context, WidgetShowcaseViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Showcase')),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WidgetShowcaseViewModel model) {
    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    return Column(
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(16), child: Text('List Data')),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Padding(padding: const EdgeInsets.all(16), child: Text('Item'));
            },
          ),
        ),
      ],
    );
  }
}
