#
#===============================================================================
#
#         FILE:  sample.t
#
#  DESCRIPTION: test 
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Weibin Yao (http://yaoweibin.cn/), yaoweibin@gmail.com
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  03/02/2010 03:18:28 PM
#     REVISION:  ---
#===============================================================================


# vi:filetype=perl

use lib 'lib';
use Test::Nginx::LWP;

plan tests => repeat_each() * 2 * blocks();

#no_diff;

run_tests();

__DATA__

=== TEST 1: the GET of HTTP
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }
--- config
    location / {
        proxy_set_header Host blog.163.com;
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_body_like: ^(.*)$

=== TEST 2: the GET of HTTP again
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }
--- config
    location / {
        proxy_set_header Host blog.163.com;
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_body_like: ^(.*)$

=== TEST 3: the GET of HTTP with variable length response
--- http_config
    upstream backend{
        server www.163.com;
        keepalive 64;
    }
--- config
    location / {
        proxy_set_header Host www.163.com;
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_body_like: ^(.*)$

=== TEST 4: the GET of HTTP with variable length response again
--- http_config
    upstream backend{
        server www.163.com;
        keepalive 64;
    }
--- config
    location / {
        proxy_set_header Host www.163.com;
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_body_like: ^(.*)$

=== TEST 5: the GET of HTTP without keepalive
--- http_config
    upstream backend{
        server www.163.com;
    }
--- config
    location / {
        proxy_set_header Host www.163.com;
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_body_like: ^(.*)$
