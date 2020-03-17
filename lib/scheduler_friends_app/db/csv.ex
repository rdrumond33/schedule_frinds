defmodule SchedulerFriendsApp.CSV do
  alias Mix.Shell.IO, as: Shell
  alias SchedulerFriendsApp.CLI.Menu
  alias SchedulerFriendsApp.CLI.Friends
  alias NimbleCSV.RFC4180, as: CSVParser
  alias SchedulerFriendsApp.CLI.Menu.Choice

  def perform(chosen_menu_item) do
    case chosen_menu_item do
      %Menu{label: _, id: :create} -> create()
      %Menu{label: _, id: :read} -> read()
      %Menu{label: _, id: :update} -> update()
      %Menu{label: _, id: :delete} -> delete()
    end

    Choice.start()
  end

  def save_csv_file(data, mode \\ []) do
    File.write!(Application.fetch_env!(:csv_file, :path), data, mode)
  end

  defp create() do
    collect_data()
    |> transform_on_wrapped_list()
    |> prepare_list_to_save_csv()
    |> save_csv_file([:append])
  end

  defp transform_on_wrapped_list(struct) do
    struct
    |> Map.from_struct()
    |> Map.values()
    |> wrap_in_list()
  end

  defp prepare_list_to_save_csv(data) do
    data
    |> CSVParser.dump_to_iodata()
  end

  defp read() do
    get_struct_list_from_csv()
    |> show_frinds
  end

  defp get_struct_list_from_csv() do
    read_csv_file()
    |> parse_csv_file_to_list()
    |> csv_list_to_friend_struct_list
  end

  defp csv_list_to_friend_struct_list(list_csv) do
    list_csv
    |> Enum.map(fn [email, name, phone] ->
      %Friends{name: name, email: email, phone: phone}
    end)
  end

  defp read_csv_file() do
    Application.fetch_env!(:csv_file, :path)
    |> File.read!()
  end

  defp parse_csv_file_to_list(csv_file) do
    csv_file
    |> CSVParser.parse_string(headers: false)
  end

  defp show_frinds(friend_list) do
    friend_list
    |> Scribe.console(data: [{"Name", :name}, {"Email", :email}, {"Phone", :phone}])
  end

  defp update() do
    Shell.cmd("clear")

    prompt_message("Digite o email do amigo")
    |> search_friend_by_email()
    |> check_friend_found()
    |> confirm_update()
    |> do_update()
  end

  defp confirm_update(friend) do
    Shell.cmd("clear")
    Shell.info("Encontramos...")

    show_friend(friend)

    case Shell.yes?("Deseja realmente autalizar esse amigo?") do
      true -> friend
      false -> :error
    end
  end

  defp do_update(friend) do
    Shell.cmd("clear")
    Shell.info("Agora voce ira digitar os novos dados do seu amigo")

    updated_friend = collect_data()

    get_struct_list_from_csv()
    |> delete_friend_from_struct_list(friend)
    |> friend_list_to_csv
    |> prepare_list_to_save_csv()
    |> save_csv_file()

    updated_friend
    |> transform_on_wrapped_list()
    |> prepare_list_to_save_csv()
    |> save_csv_file([:append])

    Shell.info("Amigo atualizado com sucesso")
    Shell.prompt("Enter...")
  end

  defp delete() do
    Shell.cmd("clear")

    prompt_message("Digite o email a ser exluido")
    |> search_friend_by_email()
    |> check_friend_found()
    |> confirm_delete()
    |> delete_save()
  end

  defp search_friend_by_email(email) do
    get_struct_list_from_csv()
    |> Enum.find(:not_found, fn list ->
      list.email == email
    end)
  end

  defp check_friend_found(friend) do
    case friend do
      :not_found ->
        Shell.cmd("clear")
        Shell.error("Amigo nao encontrado")
        Shell.prompt("Prisione enter para continuar")
        Choice.start()

      _ ->
        friend
    end
  end

  defp confirm_delete(friend) do
    Shell.cmd("clear")
    Shell.info("Encontramos...")

    show_friend(friend)

    case Shell.yes?("Deseja realmente apagar?") do
      true -> friend
      false -> :error
    end
  end

  defp show_friend(friend) do
    friend
    |> Scribe.print(data: [{"Name", :name}, {"Email", :email}, {"Phone", :phone}])
  end

  defp delete_save(friend) do
    case friend do
      :error ->
        Shell.info("Amigo nao apagado")
        Shell.prompt("presione enter")

      _ ->
        get_struct_list_from_csv()
        |> delete_friend_from_struct_list(friend)
        |> friend_list_to_csv()
        |> prepare_list_to_save_csv()
        |> save_csv_file
    end
  end

  defp delete_friend_from_struct_list(list, friend) do
    list
    |> Enum.reject(fn elem -> elem.email == friend.email end)
  end

  defp friend_list_to_csv(list) do
    list
    |> Enum.map(fn item ->
      [item.email, item.name, item.phone]
    end)
  end

  defp collect_data() do
    Shell.cmd("clear")

    %Friends{
      name: prompt_message("Name:"),
      email: prompt_message("Email:"),
      phone: prompt_message("Phone:")
    }
  end

  defp prompt_message(message) do
    Shell.prompt(message)
    |> String.trim()
  end

  defp wrap_in_list(list) do
    [list]
  end
end
