%% @author Ransom Richardson <ransom@ransomr.net>
%% @doc
%%
%% HTTP client abstraction for erlcloud. Simplifies changing http clients.
%% API matches lhttpc, except Config is passed instead of options for
%% future cusomizability.
%%
%% @end

-module(erlcloud_httpc).

-export([request/6]).

%% NOTE: erlcloud 0.4.1 expects a patched version of lhttpc that
%% returns headers as lower case strings. To support other versions of
%% lhttpc we need to downcase headers before returning them.
request(URL, Method, Hdrs, Body, Timeout, _Config) ->
    case lhttpc:request(URL, Method, Hdrs, Body, Timeout, []) of
        {ok, {Status, ResponseHdrs, ResponseBody}} ->
            HdrsLower = [{string:to_lower(K), V} || {K, V} <- ResponseHdrs],
            {ok, {Status, HdrsLower, ResponseBody}};
        Response ->
            Response
    end.
