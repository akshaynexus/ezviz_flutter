/// 萤石云打印
void ezvizLog(String msg) {
  print("EZviz Log: $msg");
}

/// 时间转换为字符串
String? dateToStr(DateTime? dateTime) {
  if (dateTime != null) {
    String dateSlug =
        "${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}";
    return dateSlug;
  }
  return null;
}

/// 通道清晰度
/// 0-流畅，1-均衡，2-高清，3-超清
class EzvizVideoLevels {
  static const Low = 0;
  static const Middle = 1;
  static const High = 2;
  static const SuperHigh = 3;

  static const levels = [Low, Middle, High, SuperHigh];

  static bool isVideolLevel(int level) {
    return levels.contains(level);
  }
}

/// 云台控制-指令类型
class EzvizPtzCommands {
  static const Left = "EZPTZCommand_Left";
  static const Right = "EZPTZCommand_Right";
  static const Up = "EZPTZCommand_Up";
  static const Down = "EZPTZCommand_Down";
  static const ZoomIn = "EZPTZCommand_ZoomIn";
  static const ZoomOut = "EZPTZCommand_ZoomOut";

  static const commands = [Left, Right, Up, Down, ZoomIn, ZoomOut];

  static bool isPtzCommand(String command) {
    return commands.contains(command);
  }
}

/// 云台控制-动作类型
class EzvizPtzActions {
  static const Start = "EZPTZAction_START";
  static const Stop = "EZPTZAction_STOP";

  static const actions = [Start, Stop];

  static bool isPtzAction(String action) {
    return actions.contains(action);
  }
}

/// 云台控制-速度类型
/// 0-慢，1-适中，2-快
class EzvizPtzSpeeds {
  static const Slow = 0;
  static const Normal = 1;
  static const Fast = 2;

  static const speeds = [Slow, Normal, Fast];

  static bool isPtzSpeed(int speed) {
    return speeds.contains(speed);
  }
}

/// 码流类型
/// 1:主码流 2:子码流
class EzvizStreamTypes {
  static const Main = 1;
  static const Sub = 2;

  static const types = [Main, Sub];

  static bool isStreamType(int type) {
    return types.contains(type);
  }
}
