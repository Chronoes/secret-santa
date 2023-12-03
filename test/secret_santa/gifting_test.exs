defmodule SecretSanta.GiftingTest do
  use SecretSanta.DataCase

  alias SecretSanta.Gifting

  describe "gifting_groups" do
    alias SecretSanta.Gifting.GiftingGroup

    import SecretSanta.GiftingFixtures

    @invalid_attrs %{name: nil}

    test "list_gifting_groups/0 returns all gifting_groups" do
      gifting_group = gifting_group_fixture()
      assert Gifting.list_gifting_groups() == [gifting_group]
    end

    test "get_gifting_group!/1 returns the gifting_group with given id" do
      gifting_group = gifting_group_fixture()
      assert Gifting.get_gifting_group!(gifting_group.id) == gifting_group
    end

    test "create_gifting_group/1 with valid data creates a gifting_group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %GiftingGroup{} = gifting_group} = Gifting.create_gifting_group(valid_attrs)
      assert gifting_group.name == "some name"
    end

    test "create_gifting_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gifting.create_gifting_group(@invalid_attrs)
    end

    test "update_gifting_group/2 with valid data updates the gifting_group" do
      gifting_group = gifting_group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %GiftingGroup{} = gifting_group} = Gifting.update_gifting_group(gifting_group, update_attrs)
      assert gifting_group.name == "some updated name"
    end

    test "update_gifting_group/2 with invalid data returns error changeset" do
      gifting_group = gifting_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Gifting.update_gifting_group(gifting_group, @invalid_attrs)
      assert gifting_group == Gifting.get_gifting_group!(gifting_group.id)
    end

    test "delete_gifting_group/1 deletes the gifting_group" do
      gifting_group = gifting_group_fixture()
      assert {:ok, %GiftingGroup{}} = Gifting.delete_gifting_group(gifting_group)
      assert_raise Ecto.NoResultsError, fn -> Gifting.get_gifting_group!(gifting_group.id) end
    end

    test "change_gifting_group/1 returns a gifting_group changeset" do
      gifting_group = gifting_group_fixture()
      assert %Ecto.Changeset{} = Gifting.change_gifting_group(gifting_group)
    end
  end

  describe "gifting_group_users" do
    alias SecretSanta.Gifting.GiftingGroupUser

    import SecretSanta.GiftingFixtures

    @invalid_attrs %{display_name: nil, is_admin: nil}

    test "list_gifting_group_users/0 returns all gifting_group_users" do
      gifting_group_user = gifting_group_user_fixture()
      assert Gifting.list_gifting_group_users() == [gifting_group_user]
    end

    test "get_gifting_group_user!/1 returns the gifting_group_user with given id" do
      gifting_group_user = gifting_group_user_fixture()
      assert Gifting.get_gifting_group_user!(gifting_group_user.id) == gifting_group_user
    end

    test "create_gifting_group_user/1 with valid data creates a gifting_group_user" do
      valid_attrs = %{display_name: "some display_name", is_admin: true}

      assert {:ok, %GiftingGroupUser{} = gifting_group_user} = Gifting.create_gifting_group_user(valid_attrs)
      assert gifting_group_user.display_name == "some display_name"
      assert gifting_group_user.is_admin == true
    end

    test "create_gifting_group_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gifting.create_gifting_group_user(@invalid_attrs)
    end

    test "update_gifting_group_user/2 with valid data updates the gifting_group_user" do
      gifting_group_user = gifting_group_user_fixture()
      update_attrs = %{display_name: "some updated display_name", is_admin: false}

      assert {:ok, %GiftingGroupUser{} = gifting_group_user} = Gifting.update_gifting_group_user(gifting_group_user, update_attrs)
      assert gifting_group_user.display_name == "some updated display_name"
      assert gifting_group_user.is_admin == false
    end

    test "update_gifting_group_user/2 with invalid data returns error changeset" do
      gifting_group_user = gifting_group_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Gifting.update_gifting_group_user(gifting_group_user, @invalid_attrs)
      assert gifting_group_user == Gifting.get_gifting_group_user!(gifting_group_user.id)
    end

    test "delete_gifting_group_user/1 deletes the gifting_group_user" do
      gifting_group_user = gifting_group_user_fixture()
      assert {:ok, %GiftingGroupUser{}} = Gifting.delete_gifting_group_user(gifting_group_user)
      assert_raise Ecto.NoResultsError, fn -> Gifting.get_gifting_group_user!(gifting_group_user.id) end
    end

    test "change_gifting_group_user/1 returns a gifting_group_user changeset" do
      gifting_group_user = gifting_group_user_fixture()
      assert %Ecto.Changeset{} = Gifting.change_gifting_group_user(gifting_group_user)
    end
  end
end
