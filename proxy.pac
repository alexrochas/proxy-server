function FindProxyForURL (url, host) {
  if (shExpMatch(url, "localhost:4567")) {
    return "PROXY 127.0.0.1:3000";
  }
  return "DIRECT";
}
