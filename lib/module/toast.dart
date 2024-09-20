import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showToast(msg, {timeInSecForIosWebs = 1, notifyTypes = ""}) {
  switch (notifyTypes) {
    case "success":
      notifyTypes = NotifyType.success;
      break;
    case "error":
      notifyTypes = NotifyType.error;
      break;
    case "failure":
      notifyTypes = NotifyType.failure;
      break;
    case "alert":
      notifyTypes = NotifyType.alert;
      break;
    case "warning":
      notifyTypes = NotifyType.warning;
      break;
    default:
      notifyTypes = NotifyType.success;
  }

  SmartDialog.showNotify(msg: msg, notifyType: notifyTypes);
}
