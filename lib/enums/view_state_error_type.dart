/// 错误类型
enum ViewStateErrorType {
  /// 默认错误
  defaultError,

  ///网络请求超时
  networkTimeout,

  /// 服务端异常
  serverError,

  /// 无网路
  noneNetwork,

  ///未授权(一般为未登录或者token失效)
  unauthorized

}
