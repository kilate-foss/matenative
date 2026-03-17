import CMate

public func vectorPushPtr<T>(_ vec: UnsafeMutablePointer<vector_t>, ptr: UnsafeMutablePointer<T>) {
  var p = ptr
  withUnsafePointer(to: &p) {
    vector_push_back(vec, UnsafeMutableRawPointer(mutating: $0))
  }
}

public func register(
  name: String,
  returnType: String,
  params: [ArgNode],
  fn: native_fn_t
) -> Bool {
  guard let node = FunctionNode(
    name: name,
    returnType: returnType,
    params: params,
    nativeFn: fn
  ) else {
    return false
  }

  native_register_function_node(node.raw)
  return true
}

public func addArgument(
  to args: inout [ArgNode],
  kind: node_value_kind_t,
  name: String
) -> Bool {
  let str = name.withCString { lstrdup($0) }

  guard let node = ArgNode(
    value: value_t(type: kind, .init(s: str))
  ) else {
    return false
  }

  args.append(node)
  return true
}

public func getArgument(
  from args: UnsafeMutablePointer<node_arg_vector_t>,
  at i: Int
) -> ArgNode? {
  guard let argPtr = vector_get(args, i) else { return nil }
  let ptr = argPtr.assumingMemoryBound(to: UnsafeMutablePointer<arg_node_t>.self).pointee
  return ArgNode(ptr)
}

public func getStringArgument(
  _ data: UnsafeMutablePointer<native_fndata_t>,
  index: Int
) -> String? {

  guard let args = data.pointee.args else {
    print("args is nil")
    return nil
  }

  guard let arg = getArgument(from: args, at: index) else {
    print("argument \(index) is nil")
    return nil
  }

  guard let value = SafeValue(with: data.pointee.inter, from: arg) else {
    print("value of argument \(index) is invalid")
    return nil
  }

  guard let str = value.toString() else {
    print("argument \(index) isn't string-compatible")
    return nil
  }

  return str
}