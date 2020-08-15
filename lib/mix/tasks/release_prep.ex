defmodule Mix.Tasks.ReleasePrep do
  use Mix.Task

  @preferred_cli_env :prod

  @impl Mix.Task
  @spec run([binary()]) :: any
  def run(args) when length(args) == 1 do
    try do
      [favicon_zip] = validate(args)
      Mix.Task.run("deps.get", ["--only", Mix.env()])
      Mix.Task.run("compile")
      Mix.Task.run("cmd", ["priv/shell/deps.sh", favicon_zip])
      Mix.Task.run("phx.digest")
    catch
      err -> Mix.shell().error(err)
    end
  end

  def run(_args) do
    Mix.shell().error("Expected path to favicon zip file")
  end

  @spec validate([binary()]) :: any
  def validate([favicon_zip]) do
    unless File.exists?(favicon_zip) do
      throw "File \"#{favicon_zip}\" does not exist"
    end

    [favicon_zip]
  end
end
