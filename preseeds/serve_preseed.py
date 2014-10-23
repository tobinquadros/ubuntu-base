#!/usr/bin/env python
#
# To grab the preseed.cfg file for preseeding Ubuntu:
# cd ubuntu-base/preseeds/
# ./serve_preseeds.py
#
# Test it with:
# curl http://localhost:8000/preseed.cfg

import SimpleHTTPServer
import SocketServer

PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port ", PORT
httpd.serve_forever()

