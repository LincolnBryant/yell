-module(yell_handler).
-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).

-define(TIME, 1000). %ms

init(Req, State) ->
    logger:debug("websocket connection initiated. request: ~p", [Req]),
    logger:debug("State: ~p", [State]),
    {cowboy_websocket, Req, State}.

websocket_init(State) ->
    logger:debug("My pid (websocket init): ~p", [self()]),
    {ok, TimerRef} = timer:send_interval(?TIME, ping),
    logger:debug("Started a timer: ~p", [TimerRef]),
    {ok, State}.

websocket_handle(pong, State) ->
    {ok, State};
websocket_handle(Data, State) ->
    logger:debug("Data from client: ~p", [Data]),
    {ok, State}.

% Send pings to the client to keep the websocket open
websocket_info(ping, State) ->
    {[ping], State};
% Send a message to the connected process. 
% THIS WILL BE SEEN BY THE USER!
websocket_info({test, Txt}, State) ->
    logger:debug("Sent message ~p to ~p", [Txt, self()]),
    {[{text, Txt}], State}.

terminate(_Reason, Req, _State) ->
    logger:debug("websocket connection terminated: ~p", [maps:get(peer, Req)]),
    ok.
