%%%-------------------------------------------------------------------
%% @doc yell public API
%% @end
%%%-------------------------------------------------------------------

-module(yell_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/ws", yell_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, [{port, 8000}], #{
        env => #{dispatch => Dispatch}
    }),
    yell_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
