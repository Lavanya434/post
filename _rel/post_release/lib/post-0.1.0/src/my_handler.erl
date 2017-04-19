-module(my_handler).

-export([init/3]).
-export([content_types_accepted/2,allowed_methods/2]).
-export([to_html/2]).

init(_, _Req, _Opts) ->
	{upgrade, protocol, cowboy_rest}.
allowed_methods(Req, State) ->
	{[<<"GET">>, <<"POST">>], Req, State}.
content_types_accepted(Req, State) ->
	{[{{<<"text">>, <<"html">>, '*'}, to_html}], Req, State}.
to_html(Req, State) ->
{ok, C} = epgsqla:start_link(),
  Ref = epgsqla:connect(C, "localhost", "postgres", "postgres", [{database, "postgres"}]),
    receive
      {C, Ref, connected} ->
        io:format("connected ~p\n", [C]);
      {C, Ref, Error = {error, _}} ->
        io:format("error is ~p", [Error])
    end,
{Query, Req1} = cowboy_req:qs(Req),
  io:format(" query string value is : ~s\n", [Query]),
 {Mail, Req2} = cowboy_req:qs_val(<<"mailid">>, Req1),
  io:format(" id is : ~s\n", [Mail]),
  {Pass, Req3} = cowboy_req:qs_val(<<"password">>, Req2),
  io:format(" password is : ~s\n", [Pass]),
  SelectRes = epgsql:equery(C, "insert into details values($1,$2)", [Mail, Pass]),
  io:format(" result is : ~p\n", [SelectRes]),
  Result1 = epgsqla:close(C),
  io:format("~s", [Result1]),
  %%SelectRes1 = epgsql:equery(C, "insert into details values(0 ,'zero')"),
  %%io:format(" result is : ~p\n", [SelectRes1]),
  Body = <<"hi">>,
	{Body,Req3, State}.
