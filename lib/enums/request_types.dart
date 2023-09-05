enum RequestTypes {
  get,
  post,
  put,
  delete,
}

RequestTypes getMethodFromString({required String value}) {
  switch (value) {
    case "get":
      return RequestTypes.get;
    case "post":
      return RequestTypes.post;
    case "put":
      return RequestTypes.put;
    case "delete":
      return RequestTypes.delete;
    default:
      return RequestTypes.get;
  }
}
