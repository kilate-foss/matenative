import CKilate

public class Node {
  var raw: UnsafeMutablePointer<node_t>

  init(_ n: UnsafeMutablePointer<node_t>) {
    raw = n
  }
}

public class FunctionNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var native: Bool {
    get {
      return (raw.pointee.function_n.native == 1) ? true : false
    }

    set(new) {
      raw.pointee.function_n.native = new ? 1 : 0
    }
  }

  var name: String? {
    get {
      guard let fnName = raw.pointee.function_n.name else { return nil }
      return String(cString: fnName)
    }

    set(new) {
      new?.withCString {
        raw.pointee.function_n.name = lstrdup($0)
      }
    }
  }

  var returnType: String? {
    get {
      guard let fnReturnType = raw.pointee.function_n.return_type else { return nil }
      return String(cString: fnReturnType)
    }

    set(new) {
      new?.withCString {
        raw.pointee.function_n.return_type = lstrdup($0)
      }
    }
  }

  var params: [ArgNode]? {
    get {
      var result: [ArgNode] = []
      guard let fnParams = raw.pointee.function_n.params else { return nil }
      let len = fnParams.pointee.size
      for i in 0 ..< len {
        guard let rawParam = vector_get(fnParams, i) else { continue }
        let paramPtr = rawParam
          .assumingMemoryBound(to: UnsafeMutablePointer<node_t>.self)
          .pointee
        result.append(ArgNode(paramPtr))
      }
      return result
    }

    set(new) {
      let vector = vector_make(MemoryLayout<UnsafeMutablePointer<param_node_t>>.size)
      for arg in new! {
        vectorPushPtr(vector!, ptr: arg.raw)
      }
      raw.pointee.function_n.params = vector
    }
  }

  var body: [Node]? {
    get {
      var result: [Node] = []
      guard let fnBody = raw.pointee.function_n.body else { return nil }
      let len = fnBody.pointee.size
      for i in 0 ..< len {
        guard let rawParam = vector_get(fnBody, i) else { continue }
        let paramPtr = rawParam
          .assumingMemoryBound(to: UnsafeMutablePointer<node_t>.self)
          .pointee
        result.append(Node(paramPtr))
      }
      return result
    }

    set(new) {
      let vector = vector_make(MemoryLayout<UnsafeMutablePointer<node_t>>.size)
      for arg in new! {
        vectorPushPtr(vector!, ptr: arg.raw)
      }
      raw.pointee.function_n.body = vector
    }
  }

  var nativeFn: native_fn_t? {
    get {
      return raw.pointee.function_n.native_fn
    }

    set(new) {
      raw.pointee.function_n.native_fn = new
    }
  }
}

public class CallNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var name: String? {
    get {
      guard let callName = raw.pointee.call_n.name else { return nil }
      return String(cString: callName)
    }

    set(new) {
      new?.withCString {
        raw.pointee.call_n.name = lstrdup($0)
      }
    }
  }

  var args: [ArgNode]? {
    get {
      var result: [ArgNode] = []
      guard let callArgs = raw.pointee.call_n.args else { return nil }

      let len = callArgs.pointee.size

      for i in 0 ..< len {
        guard let rawArg = vector_get(callArgs, i) else { continue }
        let argPtr = rawArg
          .assumingMemoryBound(to: UnsafeMutablePointer<node_t>.self)
          .pointee
        result.append(ArgNode(argPtr))
      }

      return result
    }

    set(new) {
      let vector = vector_make(MemoryLayout<UnsafeMutablePointer<arg_node_t>>.size)
      for arg in new! {
        vectorPushPtr(vector!, ptr: arg.raw)
      }
      raw.pointee.call_n.args = vector
    }
  }
}

public class ArgNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var value: value_t {
    get {
      return raw.pointee.arg_n
    }

    set(new) {
      raw.pointee.arg_n = new
    }
  }
}

public class ReturnNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var value: value_t {
    get {
      return raw.pointee.return_n
    }

    set(new) {
      raw.pointee.return_n = new
    }
  }
}

public class VarDecNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var name: String? {
    get {
      guard let varName = raw.pointee.vardec_n.name else { return nil }
      return String(cString: varName)
    }

    set(new) {
      new?.withCString {
        raw.pointee.vardec_n.name = lstrdup($0)
      }
    }
  }

  var type: String? {
    get {
      guard let varType = raw.pointee.vardec_n.type else { return nil }
      return String(cString: varType)
    }

    set(new) {
      new?.withCString {
        raw.pointee.vardec_n.type = lstrdup($0)
      }
    }
  }

  var value: value_t {
    get {
      return raw.pointee.vardec_n.value
    }

    set(new) {
      raw.pointee.vardec_n.value = new
    }
  }
}

public class ImportNode: Node {
  override init(_ n: UnsafeMutablePointer<node_t>) {
    super.init(n)
  }

  var path: String? {
    get {
      guard let p = raw.pointee.import_n.path else { return nil }
      return String(cString: p)
    }

    set(new) {
      new?.withCString {
        raw.pointee.import_n.path = lstrdup($0)
      }
    }
  }
}

public extension FunctionNode {
  convenience init?(
    name: String,
    returnType: String,
    params: [ArgNode],
    nativeFn: native_fn_t
  ) {
    guard let node = alloc_node(NODE_NATIVE_FUNCTION) else { return nil }
    self.init(node)
    self.name = name
    self.returnType = returnType
    self.params = params
    self.nativeFn = nativeFn
    native = true
  }
}

public extension ReturnNode {
  convenience init?(value: value_t) {
    guard let node = alloc_node(NODE_RETURN) else { return nil }
    self.init(node)
    self.value = value
  }
}

public extension ArgNode {
  convenience init?(value: value_t) {
    guard let node = alloc_node(NODE_ARG) else { return nil }
    self.init(node)
    self.value = value
  }
}