import CMate

public class SafeValue {
  var raw: UnsafeMutablePointer<safe_value_t>

  init?(_ p: safe_value_t) {
    guard let rawPtr = lmalloc(MemoryLayout<safe_value_t>.size) else { return nil }
    raw = rawPtr.bindMemory(to: safe_value_t.self, capacity: 1)
    raw.initialize(to: p)
  }

  deinit {
    raw.deinitialize(count: 1)
    free(raw)
  }

  func toString() -> String? {
    guard let ss = safe_to_string(raw.pointee) else { return nil }
    return String(cString: ss)
  }

  func toInt() -> Int32 {
    return safe_to_int(raw.pointee)
  }

  func toFloat() -> Float {
    return safe_to_float(raw.pointee)
  }
}

public extension SafeValue {
  convenience init?(with interpreter: UnsafeMutablePointer<interpreter_t>, from arg: ArgNode) {
    let v = get_safe_value(interpreter, arg.raw)
    self.init(v)
  }
}