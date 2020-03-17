defmodule Mix.Tasks.Start do
  use Mix.Task

  @shortdoc "Starts [frinds App]"
  def run(_), do: SchedulerFriendsApp.init()
end
