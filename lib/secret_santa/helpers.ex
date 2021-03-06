defmodule SecretSanta.Helpers do
  @doc """
  Create pairs of elements from a list of elements in a perfect cycle
  (elements are not paired with themselves and all elements form a pair)
  """
  @spec pair_up([any()]) :: [{any(), any()}]
  def pair_up([]), do: []
  def pair_up([_]), do: raise(ArgumentError, message: "Cannot form pairs from a single element")

  def pair_up(participants) do
    shuffled = Enum.shuffle(participants)

    shuffled
    |> rotate_left()
    |> Enum.zip(shuffled)
  end

  @doc """
  Rotate a list to the left. Elements will shift their positions to the left by one,
  and the first element will be the last
  """
  @spec rotate_left([any()]) :: [any()]
  def rotate_left([]), do: []
  def rotate_left([x]), do: [x]
  def rotate_left([x | rest]), do: rest |> List.insert_at(-1, x)

  @spec generate_password(non_neg_integer()) :: binary()
  def generate_password(length \\ 8) do
    [?0..?9, ?A..?Z, ?a..?z] |> Enum.concat() |> Enum.take_random(length) |> List.to_string()
  end

  @spec add_tz_to_datetime(datetime :: NaiveDateTime.t()) :: DateTime.t()
  def add_tz_to_datetime(datetime) do
    {:ok, datetimetz} =
      DateTime.from_naive!(datetime, "Etc/UTC")
      |> DateTime.shift_zone(get_default_tz())

    datetimetz
  end

  @spec get_default_tz :: binary()
  def get_default_tz do
    Application.get_env(:secret_santa, :timezone)
  end

  @spec datetime_now :: DateTime.t()
  def datetime_now do
    {:ok, datetime} = DateTime.now(SecretSanta.Helpers.get_default_tz())
    datetime
  end

  @spec format_short_date(DateTime.t() | NaiveDateTime.t()) :: binary()
  def format_short_date(datetime) do
    "#{date_zfill(datetime.day)}.#{date_zfill(datetime.month)} #{date_zfill(datetime.hour)}:#{
      date_zfill(datetime.minute)
    }"
  end

  defp date_zfill(nr), do: String.pad_leading(Integer.to_string(nr), 2, "0")
end
