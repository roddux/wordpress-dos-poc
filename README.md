# CVE-2019-XXXX: WordPress <= 5.3.? DoS

## The bug
WordPress is vulnerable to Denial-of-Service by abusing XMLRPC API. The `system.multicall` function lets you batch other API calls. Another API function is `pingback.ping`, which makes WordPress make a connection out to another site. If you batch a few thousand `pingback.ping` requests using the multicall feature, you can exhaust a variety of different resources on the server.

This will eat through Apache2's worker threads. It will also make MySQL eats up more CPU and mem, possibly killing low-RAM instances on VPS etc. NGINX installs are also vulnerable when using php-fpm, as the connections nginx<->php-fpm are exhausted. Lots of fun.

## The PoC
Simple Python3 code that repeatedly spams a target server with ~2000 multicall requests.

Usage as follows (change the check URL):
`$ ./CVE-2019-XXXX.py check http://n1p5ok9cpuh1dg2rvius5ujwun0do2.burpcollaborator.net http://192.168.0.39`

Check the response and make sure it looks like a normal pingback response. Normally takes a second or two and shouldn't display any errors.

If you're all good, proceed to use the attack mode:
`$ ./CVE-2019-XXXX.py attack http://n1p5ok9cpuh1dg2rvius5ujwun0do2.burpcollaborator.net http://192.168.0.39`
