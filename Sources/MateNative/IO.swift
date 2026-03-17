import CMate
import Foundation

func stdPrint(_ data: UnsafeMutablePointer<native_fndata_t>?) -> UnsafeMutablePointer<return_node_t>? {
  guard let data else {
    print("native fndata is nil\n")
    return nil
  }

  guard let args = data.pointee.args else {
    print("args is nil")
    return nil
  }

  var output = ""

  for i in 0..<args.pointee.size {
    guard let arg = getStringArgument(data, index: i) else {
      return nil
    }

    output += arg
  }

  print(output, terminator: "")

  return ReturnNode(value: value_t(
    type: NODE_VALUE_TYPE_INT,
    .init(i: 0)
  ))?.raw
}

func stdSystem(_ data: UnsafeMutablePointer<native_fndata_t>?) -> UnsafeMutablePointer<return_node_t>? {
  guard let data else {
    print("native fndata is nil")
    return nil
  }

  guard let cmd = getStringArgument(data, index: 0) else {
    return nil
  }

  let ret = system(cmd)

  return ReturnNode(value: value_t(
    type: NODE_VALUE_TYPE_INT,
    .init(i: ret)
  ))?.raw
}