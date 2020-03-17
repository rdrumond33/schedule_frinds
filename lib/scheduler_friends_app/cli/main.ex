defmodule SchedulerFriendsApp.CLI.Main do
  alias Mix.Shell.IO, as: Shell
  alias SchedulerFriendsApp.CLI.Menu.Choice

  def start_app() do
    Shell.cmd("clear")
    welcome_message()
    Shell.prompt("Press Enter to continue...")
  end

  def welcome_message do
    Shell.info("=======Scheduler Frinds========")
    Shell.info("Welcome this Scheduler Frinds!!")
    Shell.info("===============================")
    start_menu_choice()
  end

  defp start_menu_choice() do
    Choice.start()
  end
end
