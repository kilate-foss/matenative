import CMate
import Foundation

func stdPrint(_ data: UnsafeMutablePointer<native_fndata_t>?) -> UnsafeMutablePointer<return_node_t>? {
  guard let data = data else {
    print("native fndata is nil\n")
    return nil
  }

  guard let args = data.pointee.args else {
    print("args is nil")
    return nil
  }

  for i in 0 ..< args.pointee.size {
    guard let arg = getArg(args, i) else {
      print("argument at \(i) is nil")
      return nil
    }
    let v = get_safe_value(data.pointee.inter, arg)
    print(String(cString: safe_to_string(v)), terminator: "")
  }

  return ReturnNode(value: value_t(
    type: NODE_VALUE_TYPE_INT,
    .init(i: 0)
  ))?.raw
}

func stdSystem(_ data: UnsafeMutablePointer<native_fndata_t>?) -> UnsafeMutablePointer<return_node_t>? {
  guard let data = data else {
    print("native fndata is nil")
    return nil
  }

  guard let args = data.pointee.args else {
    print("args is nil")
    return nil
  }

  guard let cmdArg = getArg(args, 0) else {
    print("cmd argument is nil")
    return nil
  }
  let cmd = get_safe_value(data.pointee.inter, cmdArg)
  let ret = system(cmd.value.s)

  return ReturnNode(value: value_t(
    type: NODE_VALUE_TYPE_INT,
    .init(i: ret)
  ))?.raw
}
