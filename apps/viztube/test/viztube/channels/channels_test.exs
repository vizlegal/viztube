defmodule Viztube.ChannelsTest do
  use Viztube.DataCase
  alias Viztube.Channels
  alias Viztube.Accounts

  @valid_attrs %{last_checked: NaiveDateTime.utc_now, tags: "Untagged", user_id: 1 }
  @valid_user_attrs %{email: "test@example.com", admin: false, tags: "Untagged"}
  @invalid_attrs %{tags: "Untagged"}
  @valid_data_attrs %{description: "example desc", title: "my example channel", channel_id: "123123", videos: 0 }
  @valid_video_attrs %{channel_id: "434234", channel_title: "Example Channel", description: "This is an example Video", etag: "asdkajf89aeakm2", published_at: NaiveDateTime.utc_now, thumbnails: %{}, video_id: "asdasd24_adaw"}

  describe "channels" do
    alias Viztube.Channels.Channel
    alias Viztube.Accounts.User

    test "changeset with valid attributes" do
      changeset = Channel.changeset(%Channel{}, @valid_attrs)
      assert changeset.valid?
    end
    
    test "changeset with invalid attributes" do
      changeset = Channel.changeset(%Channel{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)

      assert {:ok, %Channel{} = channel} = Channels.create_channel(Map.put(@valid_attrs, :user_id, user.id))
      assert channel.last_checked.hour == NaiveDateTime.utc_now.hour
    end

    test "list_channels/1 returns all channels" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)      
      assert {:ok, %Channel{} = channel} = Channels.create_channel(Map.put(@valid_attrs, :user_id, user.id))
      assert Channels.list_channels(user.id, 1).page_number == 1
    end

    test "get_channel!/1 returns the channel with given id" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)      
      assert {:ok, %Channel{} = channel} = Channels.create_channel(Map.put(@valid_attrs, :user_id, user.id))
      
       {:ok, ch} = Channels.get_channel(user.id, channel.id)
       assert ch.id == channel.id
    end

    # TODO test invalid data
    # test "create_channel/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs)
    # end

    test "delete_channel/1 deletes the channel" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)      
      assert {:ok, %Channel{} = channel} = Channels.create_channel(Map.put(@valid_attrs, :user_id, user.id))

      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
    end

  end

  describe "channel_videos" do
    # alias Viztube.Channels.Resource
    # alias Viztube.Channels.Channel
    # alias Viztube.Accounts.User

    # test "create_resource/1 with valid data creates a resource" do
    #   assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)      
    #   assert {:ok, %Channel{} = channel} = Channels.create_channel(Map.put(@valid_attrs, :user_id, user.id))

      
    #   # assert {:ok, %Resource{} = resource} = Channels.create_resource(%{channel: channel.id, data: Map.put(@valid_video_attrs, :channel_id, channel.id)})
    #   # assert resource.data.title == "An example video"
    # end

    # # TODO test invalid data
    # # test "create_resource/1 with invalid data returns error changeset" do
    # #   assert {:error, %Ecto.Changeset{}} = Channels.create_resource(@invalid_attrs)
    # # end

    # # TODO update resource
    # # test "update_resource/2 with valid data updates the resource" do
    # #   resource = insert(:resource)
    # #   assert {:ok, resource} = Channels.update_resource(resource, @update_attrs)
    # #   assert %Resource{} = resource
    # #   assert resource.data == "some updated data"
    # # end

    # # test "update_resource/2 with invalid data returns error changeset" do
    # #   resource = resource_fixture()
    # #   assert {:error, %Ecto.Changeset{}} = Channels.update_resource(resource, @invalid_attrs)
    # #   assert resource == Channels.get_resource!(resource.id)
    # # end

    # # test "delete_resource/1 deletes the resource" do
    # #   resource = resource_fixture()
    # #   assert {:ok, %Resource{}} = Channels.delete_resource(resource)
    # #   assert_raise Ecto.NoResultsError, fn -> Channels.get_resource!(resource.id) end
    # # end
    # #
    # # test "change_resource/1 returns a resource changeset" do
    # #   resource = resource_fixture()
    # #   assert %Ecto.Changeset{} = Channels.change_resource(resource)
    # # end
  end
end
