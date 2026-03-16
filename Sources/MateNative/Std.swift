import CMate

@_cdecl("MATE_NATIVE_REGISTER")
public func mregister() {
  var params: [ArgNode] = []
  addArg(
    to: &params,
    kind: NODE_VALUE_TYPE_ANY,
    name: "value"
  )
  register(
    name: "Print",
    returnType: "Int",
    params: params,
    fn: stdPrint
  )

  params.removeAll()

  addArg(
    to: &params,
    kind: NODE_VALUE_TYPE_ANY,
    name: "value"
  )
  register(
    name: "Print",
    returnType: "Int",
    params: params,
    fn: stdPrint
  )
}
