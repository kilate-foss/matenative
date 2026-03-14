import CMate

@_cdecl("MATE_NATIVE_REGISTER")
public func register() {
  var params: [ArgNode] = []
  addArg(&params, NODE_VALUE_TYPE_ANY, "value")
  registerNativeFunction("Print", "Int", params, stdPrint)

  params.removeAll()
  addArg(&params, NODE_VALUE_TYPE_STRING, "cmd")
  registerNativeFunction("System", "Int", params, stdSystem)
}
