defmodule Mix.Tasks.Utils.AddFakerFriends do
  use Mix.Task

  alias SchedulerFriendsApp.CLI.Friends
  alias NimbleCSV.RFC4180, as: CSVParser
  alias SchedulerFriendsApp.CSV

  @shortdoc "Add Fake Friends on App"
  def run(_) do
    Faker.start()

    create_friends([], 50)
    |> CSVParser.dump_to_iodata()
    |> CSV.save_csv_file([:append])
  end

  defp create_friends(list, count) when count <= 1 do
    list ++ [ramdon_lisst_friends()]
  end

  defp create_friends(list, count) do
    list ++ [ramdon_lisst_friends()] ++ create_friends(list, count - 1)
  end

  defp ramdon_lisst_friends() do
    %Friends{
      name: Faker.Name.PtBr.name(),
      email: Faker.Internet.email(),
      phone: Faker.Phone.EnUs.phone()
    }
    |> Map.from_struct()
    |> Map.values()
    |> List.wrap()
  end
end
