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

    proxy_cache_path /tmp/http_cache_test levels=1:2 keys_zone=http_cache_zone:10m inactive=24h max_size=1g;

--- config
    location / {
        proxy_cache "http_cache_zone";
        proxy_cache_key "$host$request_uri$cookie_user";
        proxy_cache_valid 200 1d;
        proxy_cache_use_stale error timeout invalid_header updating http_500;
        add_header X-Cache $upstream_cache_status;

        proxy_set_header Host www.163.com;
        proxy_set_header Connection "keep-alive";

        proxy_pass http://backend;
    }
--- request
    GET /
--- response_headers
    X-Cache: MISS

=== TEST 2: GET file HIT at second time
--- http_config
    upstream backend{
        server www.163.com;
        keepalive 64;
    }

    proxy_cache_path /tmp/http_cache_test levels=1:2 keys_zone=http_cache_zone:10m inactive=24h max_size=1g;

--- config
    location / {
        proxy_cache "http_cache_zone";
        proxy_cache_key "$host$request_uri$cookie_user";
        proxy_cache_valid 200 1d;
        proxy_cache_use_stale error timeout invalid_header updating http_500;
        add_header X-Cache $upstream_cache_status;

        proxy_set_header Host www.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_headers
    X-Cache: HIT

=== TEST 3: GET file MISS at first time
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }

    proxy_cache_path /tmp/http_cache_test levels=1:2 keys_zone=http_cache_zone:10m inactive=24h max_size=1g;

--- config
    location / {
        proxy_cache "http_cache_zone";
        proxy_cache_key "blog.163.com$request_uri$cookie_user";
        proxy_cache_valid 200 1d;
        proxy_cache_use_stale error timeout invalid_header updating http_500;
        add_header X-Cache $upstream_cache_status;

        proxy_set_header Host blog.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_headers
    X-Cache: MISS

=== TEST 4: GET file MISS again, because the blog.163.com disable cache
--- http_config
    upstream backend{
        server blog.163.com;
        keepalive 64;
    }

    proxy_cache_path /tmp/http_cache_test levels=1:2 keys_zone=http_cache_zone:10m inactive=24h max_size=1g;

--- config
    location / {
        proxy_cache "http_cache_zone";
        proxy_cache_key "blog.163.com$request_uri$cookie_user";
        proxy_cache_valid 200 1d;
        proxy_cache_use_stale error timeout invalid_header updating http_500;
        add_header X-Cache $upstream_cache_status;

        proxy_set_header Host blog.163.com;
        proxy_set_header Connection "keep-alive";
        proxy_pass http://backend;
    }
--- request
    GET /
--- response_headers
    X-Cache: MISS
