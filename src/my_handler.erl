-module(my_handler).

-export([init/3,terminate/3]).
-export([resource_exists/2,allow_missing_post/2,content_types_accepted/2,allowed_methods/2]).
-export([welcome/2]).

init(_, _Req, _Opts) ->
	{upgrade, protocol, cowboy_rest}.

resource_exists(Req, State) ->
  {false, Req, State}.
allowed_methods(Req, State) ->
  {[<<"POST">>], Req, State}.

allow_missing_post(Req, State) ->
  {true, Req, State}.
  
content_types_accepted(Req, State) ->
  {[{{<<"application">>, <<"x-www-form-urlencoded">>, '*'}, welcome}], Req, State}.

terminate(_Reason, _Req, _State) ->
  ok.
welcome(Req, State) ->
  {ok, C} = epgsqla:start_link(),
  Ref = epgsqla:connect(C, "localhost", "postgres", "postgres", [{database, "postgres"}]),
  receive
    {C, Ref, connected} ->
      io:format("connected ~p", [C]);
    {C, Ref, Error = {error, _}} ->
          io:format("error is ~p", [Error])
  end,
  Req1 = cowboy_req:set_resp_header(<<"allow">>, "POST", Req),
  Req2 = cowboy_req:set_resp_body(<<"HELLO POST">>, Req1),
  {ok, KeyValues, Req3} = cowboy_req:body_qs(Req2),
  {_, Id} = lists:keyfind(<<"mailid">>, 1, KeyValues),
  io:format("mailid is ~s\n", [Id]),
  {_, Pass} = lists:keyfind(<<"password">>, 1, KeyValues),
  io:format("password is ~s\n", [Pass]),
  SelectRes = epgsql:equery(C, "insert into details values($1,$2)", [Id, Pass]),
  io:format("inserted ~p\n", [SelectRes]),
  Close = epgsqla:close(C),
  io:format("~s", [Close]),
  {true, Req3, State}.
