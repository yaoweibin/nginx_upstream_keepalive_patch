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

=== TEST 1: GET file MISS at first time
--- http_config
    upstream backend{
        server www.163.com;
        keepalive 64;
    }

--- config
    location / {
        root                 /tmp/proxy_store_test;
        error_page           404 = /fetch$uri;
    }

    location /fetch {
        internal;

        proxy_store          on;
        proxy_store_access   user:rw  group:rw  all:r;
        proxy_temp_path      /tmp/proxy_store_test;
        alias                /tmp/proxy_store_test;

        proxy_set_header Host www.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /index.html
--- response_body_like: ^(.*)$

=== TEST 2: GET file HIT at second time
--- http_config
    upstream backend{
        server www.163.com;
        keepalive 64;
    }

--- config
    location / {
        root                 /tmp/proxy_store_test;
        error_page           404 = /fetch$uri;
    }

    location /fetch {
        internal;

        proxy_store          on;
        proxy_store_access   user:rw  group:rw  all:r;
        proxy_temp_path      /tmp/proxy_store_test;
        alias                /tmp/proxy_store_test;

        proxy_set_header Host www.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /index.html
--- response_body_like: ^(.*)$

=== TEST 3: GET file MISS at first time
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }

--- config
    location / {
        root                 /tmp/proxy_store_test;
        error_page           404 = /fetch$uri;
    }

    location /fetch {
        internal;

        proxy_store          on;
        proxy_store_access   user:rw  group:rw  all:r;
        proxy_temp_path      /tmp/proxy_store_test;
        alias                /tmp/proxy_store_test;

        proxy_set_header Host blog.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /classify/index.do
--- response_body_like: ^(.*)$

=== TEST 4: GET file MISS again, because the blog.163.com disable cache
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }

--- config
    location / {
        root                 /tmp/proxy_store_test;
        error_page           404 = /fetch$uri;
    }

    location /fetch {
        internal;

        proxy_store          on;
        proxy_store_access   user:rw  group:rw  all:r;
        proxy_temp_path      /tmp/proxy_store_test;
        alias                /tmp/proxy_store_test;

        proxy_set_header Host blog.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /classify/index.do
--- response_body_like: ^(.*)$
