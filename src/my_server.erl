-module(my_server).
-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {conn}).

start_link(Args) ->
io:format("ho"),
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    process_flag(trap_exit, true),
    Hostname = proplists:get_value(hostname, Args),
    Database = proplists:get_value(database, Args),
    Username = proplists:get_value(username, Args),
    Password = proplists:get_value(password, Args),
    {ok, Conn} = epgsqla:start_link(),
    io:format("hi"),    
  Ref = epgsqla:connect(Conn, Hostname,Username, Password, [{database, Database}]),
 receive
    {Conn, Ref, connected} ->
        {ok, #state{conn=Conn}};
   {Conn, Ref, Error = {error, _ }} ->
       io:format("~s", [Error])
  end.

  
handle_call({squery, Sql}, _From, #state{conn=Conn}=State) ->
    {reply, epgsql:squery(Conn, Sql), State};
handle_call({equery, Stmt, Params}, _From, #state{conn=Conn}=State) ->
    case epgsql:equery(Conn, Stmt, Params) of
            {ok , _} ->
                {reply, epgsql:equery(Conn, Stmt, Params), State};
            {error, Error} ->
              {reply, Error, State}  
    end;
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.
handle_info({'EXIT', Ref, _Reason}, State) ->
    io:format("exited ~p", [Ref]),
   {stop, _Reason, State}.

terminate(Error, #state{conn=Conn}) ->
    io:format("terminating with reason ~s", [Error]),
    ok = epgsql:close(Conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.