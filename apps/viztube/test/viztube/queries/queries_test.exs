defmodule Viztube.QueriesTest do
  use Viztube.DataCase
  alias Viztube.Queries

  describe "searches" do
    alias Viztube.Queries.Search

    # test "list_searches/0 returns all searches" do
    #   search = search_fixture()
    #   assert Queries.list_searches() == [search]
    # end

    # test "get_search!/1 returns the search with given id" do
    #   search = search_fixture()
    #   assert Queries.get_search!(search.id) == search
    # end

    #   test "create_search/1 with valid data creates a search" do
    #     assert {:ok, %Search{} = search} = Queries.create_search(@valid_attrs)
    #     assert search.last_checked == ~D[2010-04-17]
    #     assert search.value == "some value"
    #   end
    #
    #   test "create_search/1 with invalid data returns error changeset" do
    #     assert {:error, %Ecto.Changeset{}} = Queries.create_search(@invalid_attrs)
    #   end
    #
    #   test "update_search/2 with valid data updates the search" do
    #     search = search_fixture()
    #     assert {:ok, search} = Queries.update_search(search, @update_attrs)
    #     assert %Search{} = search
    #     assert search.last_checked == ~D[2011-05-18]
    #     assert search.value == "some updated value"
    #   end
    #
    #   test "update_search/2 with invalid data returns error changeset" do
    #     search = search_fixture()
    #     assert {:error, %Ecto.Changeset{}} = Queries.update_search(search, @invalid_attrs)
    #     assert search == Queries.get_search!(search.id)
    #   end
    #
    #   test "delete_search/1 deletes the search" do
    #     search = search_fixture()
    #     assert {:ok, %Search{}} = Queries.delete_search(search)
    #     assert_raise Ecto.NoResultsError, fn -> Queries.get_search!(search.id) end
    #   end
    #
    #   test "change_search/1 returns a search changeset" do
    #     search = search_fixture()
    #     assert %Ecto.Changeset{} = Queries.change_search(search)
    #   end
    end

    describe "results" do
      alias Viztube.Queries.Result

    #   test "list_results/0 returns all results" do
    #     result = result_fixture()
    #     assert Queries.list_results() == [result]
    #   end
    #
    #   test "get_result!/1 returns the result with given id" do
    #     result = result_fixture()
    #     assert Queries.get_result!(result.id) == result
    #   end
    #
    #   test "create_result/1 with valid data creates a result" do
    #     assert {:ok, %Result{} = result} = Queries.create_result(@valid_attrs)
    #     assert result.value == "some value"
    #   end
    #
    #   test "create_result/1 with invalid data returns error changeset" do
    #     assert {:error, %Ecto.Changeset{}} = Queries.create_result(@invalid_attrs)
    #   end
    #
    #   test "update_result/2 with valid data updates the result" do
    #     result = result_fixture()
    #     assert {:ok, result} = Queries.update_result(result, @update_attrs)
    #     assert %Result{} = result
    #     assert result.value == "some updated value"
    #   end
    #
    #   test "update_result/2 with invalid data returns error changeset" do
    #     result = result_fixture()
    #     assert {:error, %Ecto.Changeset{}} = Queries.update_result(result, @invalid_attrs)
    #     assert result == Queries.get_result!(result.id)
    #   end
    #
    #   test "delete_result/1 deletes the result" do
    #     result = result_fixture()
    #     assert {:ok, %Result{}} = Queries.delete_result(result)
    #     assert_raise Ecto.NoResultsError, fn -> Queries.get_result!(result.id) end
    #   end
    #
    #   test "change_result/1 returns a result changeset" do
    #     result = result_fixture()
    #     assert %Ecto.Changeset{} = Queries.change_result(result)
    #   end
  end

  describe "channels" do
    alias Viztube.Queries.Channel

    # test "list_channels/0 returns all channels" do
    #   channel = channel_fixture()
    #   assert Queries.list_channels() == [channel]
    # end
    #
    # test "get_channel!/1 returns the channel with given id" do
    #   channel = channel_fixture()
    #   assert Queries.get_channel!(channel.id) == channel
    # end
    #
    # test "create_channel/1 with valid data creates a channel" do
    #   assert {:ok, %Channel{} = channel} = Queries.create_channel(@valid_attrs)
    #   assert channel.last_checked == ~D[2010-04-17]
    #   assert channel.value == "some value"
    # end
    #
    # test "create_channel/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Queries.create_channel(@invalid_attrs)
    # end
    #
    # test "update_channel/2 with valid data updates the channel" do
    #   channel = channel_fixture()
    #   assert {:ok, channel} = Queries.update_channel(channel, @update_attrs)
    #   assert %Channel{} = channel
    #   assert channel.last_checked == ~D[2011-05-18]
    #   assert channel.value == "some updated value"
    # end
    #
    # test "update_channel/2 with invalid data returns error changeset" do
    #   channel = channel_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Queries.update_channel(channel, @invalid_attrs)
    #   assert channel == Queries.get_channel!(channel.id)
    # end
    #
    # test "delete_channel/1 deletes the channel" do
    #   channel = channel_fixture()
    #   assert {:ok, %Channel{}} = Queries.delete_channel(channel)
    #   assert_raise Ecto.NoResultsError, fn -> Queries.get_channel!(channel.id) end
    # end
    #
    # test "change_channel/1 returns a channel changeset" do
    #   channel = channel_fixture()
    #   assert %Ecto.Changeset{} = Queries.change_channel(channel)
    # end
  end
end
