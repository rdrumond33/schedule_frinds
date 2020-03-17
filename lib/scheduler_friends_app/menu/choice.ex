defmodule SchedulerFriendsApp.CLI.Menu.Choice do
  alias Mix.Shell.IO, as: Shell
  alias SchedulerFriendsApp.CLI.Menu.Itens
  alias SchedulerFriendsApp.CSV

  def start() do
    Shell.cmd("clear")
    Shell.info("Actions:")

    menu_itens = Itens.all()

    find_menu_item_by_index = &Enum.at(menu_itens, &1, :error)

    menu_itens
    |> Enum.map(& &1.label)
    |> display_options
    |> generate_question()
    |> Shell.prompt()
    |> parse_answer()
    |> find_menu_item_by_index.()
    |> confirm_menu_item()
    |> confirm_message()
    |> CSV.perform()
  end

  defp display_options(options) do
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} ->
      Shell.info("#{index} - #{option}")
    end)

    options
  end

  defp generate_question(options) do
    options = Enum.join(1..Enum.count(options), ",")
    "Qual das opcoes acima voce quer [#{options}]"
  end

  defp parse_answer(answer) do
    case Integer.parse(answer) do
      :error -> invalid_option()
      {option, _} -> option - 1
    end
  end

  defp confirm_menu_item(choise) do
    case choise do
      :error -> invalid_option()
      _ -> choise
    end
  end

  defp confirm_message(choise) do
    Shell.cmd("clear")
    Shell.info("Voce escolheu #{choise.label}")

    if Shell.yes?("confirmar?") do
      choise
    else
      start()
    end
  end

  defp invalid_option() do
    Shell.cmd("clear")
    Shell.error("Invalid options")
    Shell.prompt("Prensione Enter para tentar novamente")
    start()
  end
end
