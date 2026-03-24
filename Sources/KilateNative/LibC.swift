#if os(Linux)
  import Glibc
#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#elseif os(Android)
  import Bionic
#endif

func lmalloc(_ bytes: Int) -> UnsafeMutableRawPointer! {
  return malloc(bytes)
}

func lstrdup(_ s: UnsafePointer<CChar>) -> UnsafeMutablePointer<CChar> {
  return strdup(s)
}
