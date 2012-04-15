%%
%% This file is part of riak_mongo
%%
%% Copyright (c) 2012 by Pavlo Baron (pb at pbit dot org)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%

%% @author Pavlo Baron <pb at pbit dot org>
%% @doc This is the worker supervisor
%% @copyright 2012 Pavlo Baron

-module(riak_mongo_worker_sup).
-behaviour(supervisor).

-export([start_link/0, init/1, new_worker/2]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    WorkerSpec = {worker,
                  {riak_mongo_worker, start_link, []},
                  temporary, brutal_kill, worker, [riak_mongo_worker]},
    {ok, {{simple_one_for_one, 0, 1}, [WorkerSpec]}}.

new_worker(Sock, Owner) ->
    supervisor:start_child(riak_mongo_worker_sup, [Sock, Owner]).
