# WordPress <= 5.3.? DoS

## The bug
WordPress is vulnerable to Denial-of-Service by abusing XMLRPC API. The `system.multicall` function lets you batch other API calls. Another API function is `pingback.ping`, which makes WordPress make a connection out to another site. If you batch a few thousand `pingback.ping` requests using the multicall feature, you can exhaust a variety of different resources on the server.

The issue boils down to the fact that, on Linux/*nix systems, PHP doesn't tally time spent on non-PHP code into the 'max_execution_time' statistic. This means that time spent waiting for cURL requests to complete isn't accounted for. A single `system.multicall` request containing some 2000 pingback calls can tie up resources for well over 10 minutes, even if the php.ini directive states `max_execution_time = 30`. I emailed security@php.net about this; I've not heard back.

Anyway. This PoC will eat through Apache2's worker threads and will also make MySQL eat up more CPU and mem, possibly knocking over low-RAM VPS instances. NGINX installs are also vulnerable when using php-fpm, as the connections nginx<->php-fpm are exhausted. Lots of fun.

## The PoC
Simple Python3 code that repeatedly spams a target server with ~2000 multicall requests. We can check if a site is vulnerable by using the excellent https://webhook.site service.

Usage as follows (change the check URL to your own):
`$ ./poc.py check https://webhook.site/#!/blah-blah-blah http://target.url`

After running the above, if your webhook.site page shows a couple requests coming through then the target site is vulnerable. Proceed to use the attack mode: `$ ./poc.py attack http://google.ru/?q=epstein%20didnt%20kill%20himself http://target.url`
