defmodule Viztube.AccountsTest do
  use Viztube.DataCase
  alias Viztube.Accounts

  @valid_attrs %{email: "test@example.com", admin: false, tags: "Untagged"}
  @invalid_attrs %{}

  describe "users" do
    alias Viztube.Accounts.User

    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end
    
    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
    
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert hd(user.tags).name == "Untagged"
    end

    # # TODO test invalid creation
    # test "create_user/1 with invalid data returns error changeset" do
    #   #assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_user_attrs)
    # end

    test "update_user/2 with valid data updates the user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} = Accounts.update_user(user, %{ admin: true })
      assert %User{} = user
      assert user.admin == true
    end

    test "update_user/2 with invalid data returns error changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{admin: nil})
    end

    test "delete_user/1 deletes the user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

  end

  # describe "auth_tokens" do
  #   alias Viztube.Accounts.AuthToken

  #   # test "list_auth_tokens/0 returns all auth_tokens" do
  #   #   auth_token = auth_token_fixture()
  #   #   # assert Accounts.list_auth_tokens() == [auth_token]
  #   # end

  #   test "get_auth_token!/1 returns the auth_token with given id" do
  #     assert {:ok, %AuthToken{} = token} = Accounts.create_auth_token()
  #     assert Accounts.get_auth_token!(token).value == token.value
  #   end

  #   # test "create_auth_token/1 with valid data creates a auth_token" do
  #   #   token = insert(:auth_token)
  #   #   assert token.value
  #   # end

  #   # test "delete_auth_token/1 deletes the auth_token" do
  #   #   auth_token = insert(:auth_token)
  #   #   assert {:ok, %AuthToken{}} = Accounts.delete_auth_token(auth_token)
  #   #   assert_raise Ecto.NoResultsError, fn -> Accounts.get_auth_token!(auth_token.id) end
  #   # end

  # end
end
