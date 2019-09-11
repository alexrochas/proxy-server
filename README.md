# Proxy Server
> minor project with the objective of add headers to rest calls

## How

Serving **proxy.pac** file with:

```bash
~/path/to/project/$ python -m SimpleHTTPServer
```

Registering the proxy with:

```bash
# MacOS only
~/$ networksetup -setautoproxyurl "Wi-Fi" "http://localhost:8000/proxy.pac"
```

Start proxy:

```bash
~/path/to/project/$ ruby proxy.rb
```

The rules on the **proxy.pac** define which url will use the proxy:

```javascript
function FindProxyForURL (url, host) {
  if (shExpMatch(url, "*local:4567*")) {
    return "PROXY 127.0.0.1:3000";
  }
  return "DIRECT";
}
```

## Pitfalls

* Google Chrome bypass localhost by default. In order to make work for localhost you need to do this "hack":

```bash
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
127.0.0.1       local # add this line
255.255.255.255	broadcasthost
::1             localhost
```

* Https calls don't let you add headers once is already encrypted.

```ruby
  def do_CONNECT(req, res) # https handler
    puts('Enhancing HTTPS request!')
    req.raw_header << "Authorization: Bearer #{@@token}" # not work
    req.header['Authorization'] = ["Bearer #{@@token}"] # not work
    super(req, res)
  end
```

## Meta

Alex Rocha - [about.me](http://about.me/alex.rochas) -