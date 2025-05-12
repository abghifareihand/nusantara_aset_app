import 'package:nusantara_aset_app/core/base/base_view_model.dart';

class ExportDataViewModel extends BaseViewModel {
  @override
  Future<void> initModel() async {
    setLoading(true);
    setLoading(false);
  }
}
