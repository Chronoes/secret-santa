defmodule SecretSanta.GiftingTest do
  use SecretSanta.DataCase

  alias SecretSanta.Gifting

  describe "wishes" do
    alias SecretSanta.Gifting.Wish

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def wish_fixture(attrs \\ %{}) do
      {:ok, wish} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gifting.create_wish()

      wish
    end

    test "list_wishes/0 returns all wishes" do
      wish = wish_fixture()
      assert Gifting.list_wishes() == [wish]
    end

    test "get_wish!/1 returns the wish with given id" do
      wish = wish_fixture()
      assert Gifting.get_wish!(wish.id) == wish
    end

    test "create_wish/1 with valid data creates a wish" do
      assert {:ok, %Wish{} = wish} = Gifting.create_wish(@valid_attrs)
    end

    test "create_wish/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gifting.create_wish(@invalid_attrs)
    end

    test "update_wish/2 with valid data updates the wish" do
      wish = wish_fixture()
      assert {:ok, %Wish{} = wish} = Gifting.update_wish(wish, @update_attrs)
    end

    test "update_wish/2 with invalid data returns error changeset" do
      wish = wish_fixture()
      assert {:error, %Ecto.Changeset{}} = Gifting.update_wish(wish, @invalid_attrs)
      assert wish == Gifting.get_wish!(wish.id)
    end

    test "delete_wish/1 deletes the wish" do
      wish = wish_fixture()
      assert {:ok, %Wish{}} = Gifting.delete_wish(wish)
      assert_raise Ecto.NoResultsError, fn -> Gifting.get_wish!(wish.id) end
    end

    test "change_wish/1 returns a wish changeset" do
      wish = wish_fixture()
      assert %Ecto.Changeset{} = Gifting.change_wish(wish)
    end
  end

  describe "gifting_pool" do
    alias SecretSanta.Gifting.GiftingPool

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def gifting_pool_fixture(attrs \\ %{}) do
      {:ok, gifting_pool} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gifting.create_gifting_pool()

      gifting_pool
    end

    test "list_gifting_pool/0 returns all gifting_pool" do
      gifting_pool = gifting_pool_fixture()
      assert Gifting.list_gifting_pool() == [gifting_pool]
    end

    test "get_gifting_pool!/1 returns the gifting_pool with given id" do
      gifting_pool = gifting_pool_fixture()
      assert Gifting.get_gifting_pool!(gifting_pool.id) == gifting_pool
    end

    test "create_gifting_pool/1 with valid data creates a gifting_pool" do
      assert {:ok, %GiftingPool{} = gifting_pool} = Gifting.create_gifting_pool(@valid_attrs)
    end

    test "create_gifting_pool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gifting.create_gifting_pool(@invalid_attrs)
    end

    test "update_gifting_pool/2 with valid data updates the gifting_pool" do
      gifting_pool = gifting_pool_fixture()
      assert {:ok, %GiftingPool{} = gifting_pool} = Gifting.update_gifting_pool(gifting_pool, @update_attrs)
    end

    test "update_gifting_pool/2 with invalid data returns error changeset" do
      gifting_pool = gifting_pool_fixture()
      assert {:error, %Ecto.Changeset{}} = Gifting.update_gifting_pool(gifting_pool, @invalid_attrs)
      assert gifting_pool == Gifting.get_gifting_pool!(gifting_pool.id)
    end

    test "delete_gifting_pool/1 deletes the gifting_pool" do
      gifting_pool = gifting_pool_fixture()
      assert {:ok, %GiftingPool{}} = Gifting.delete_gifting_pool(gifting_pool)
      assert_raise Ecto.NoResultsError, fn -> Gifting.get_gifting_pool!(gifting_pool.id) end
    end

    test "change_gifting_pool/1 returns a gifting_pool changeset" do
      gifting_pool = gifting_pool_fixture()
      assert %Ecto.Changeset{} = Gifting.change_gifting_pool(gifting_pool)
    end
  end
end
