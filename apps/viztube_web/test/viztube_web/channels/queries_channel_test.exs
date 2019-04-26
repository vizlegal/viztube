defmodule ViztubeWeb.QueriesChannelTest do
  use ViztubeWeb.ChannelCase

  alias ViztubeWeb.QueryChannel

  # setup do
  #   {:ok, _, socket} =
  #     socket("user_id", %{})
  #     |> subscribe_and_join(QueryChannel, "queries:lobby")
  #
  #   {:ok, socket: socket}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   # ref = push socket, "update", %{"hello" => "there"}
  #   # assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "shout broadcasts to queries:lobby", %{socket: socket} do
  #   push socket, "update", %{"id" => "1"}
  #   assert_broadcast "update", %{"id" => "1"}
  # end
  #
  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   # broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   # assert_push "broadcast", %{"some" => "data"}
  # end
end
