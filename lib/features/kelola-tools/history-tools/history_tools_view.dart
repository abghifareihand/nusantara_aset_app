import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/kelola-tools/tools_view_model.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_tools.dart';

class HistoryToolsView extends StatelessWidget {
  const HistoryToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ToolsViewModel>(
      model: ToolsViewModel(),
      onModelReady: (model) => model.initModel(),
      onModelDispose: (model) => model.disposeModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('History Tools'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ToolsViewModel model) {
    if (model.toolsList.isEmpty) {
      return const Center(child: Text('History Tools Kosong', style: TextStyle(fontSize: 16)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: model.toolsList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final data = model.toolsList[index];
        return ItemCardTools(
          data: data,
          isExpanded: model.expandedIndexes.contains(index),
          onTap: () => model.toggleExpanded(index),
          onLongPress: () => _showDeleteDialog(context, model, data.id),
          onDelete: () => _showDeleteItemDialog(context, model, data.id, index),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ToolsViewModel model, String toolsId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Tools',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deleteToolsData(toolsId);
            navigator.pop();
          },
        );
      },
    );
  }

  void _showDeleteItemDialog(
    BuildContext context,
    ToolsViewModel model,
    String parentId,
    int itemId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Item Tools',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deleteToolsListItem(parentId: parentId, itemIndex: itemId);
            navigator.pop();
          },
        );
      },
    );
  }
}
