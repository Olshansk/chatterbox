-module(http2_frame_rst_stream).

-export([read_binary/2]).

-include("http2.hrl").

-behavior(http2_frame).

-spec read_binary(binary(), frame_header()) ->
    {ok, payload(), binary()} |
    {error, term()}.
read_binary(_, #frame_header{stream_id=0}) ->
    {error, connection_error};
read_binary(<<ErrorCode:4/binary,Rem/bits>>, #frame_header{length=4}) ->
    Payload = #rst_stream{
                 error_code = ErrorCode
                },
    {ok, Payload, Rem};
read_binary(_, #frame_header{stream_id=0}) ->
    {error, frame_size_error}.
