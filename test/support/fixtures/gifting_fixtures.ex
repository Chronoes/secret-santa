defmodule SecretSanta.GiftingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SecretSanta.Gifting` context.
  """

  @doc """
  Generate a gifting_group.
  """
  def gifting_group_fixture(attrs \\ %{}) do
    {:ok, gifting_group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SecretSanta.Gifting.create_gifting_group()

    gifting_group
  end

  @doc """
  Generate a gifting_group_user.
  """
  def gifting_group_user_fixture(attrs \\ %{}) do
    {:ok, gifting_group_user} =
      attrs
      |> Enum.into(%{
        display_name: "some display_name",
        is_admin: true
      })
      |> SecretSanta.Gifting.create_gifting_group_user()

    gifting_group_user
  end
end
