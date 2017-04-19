-module(post_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, post, "login.html"}},
			{"/[my_handler]", my_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8088}], 
	[
		
		{env, [{dispatch, Dispatch}]}
		
		
	]),		
post_sup:start_link().

stop(_State) ->
	ok.
