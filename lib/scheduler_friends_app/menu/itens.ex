defmodule SchedulerFriendsApp.CLI.Menu.Itens do
  alias SchedulerFriendsApp.CLI.Menu

  def all,
    do: [
      %Menu{label: "Create frinds", id: :create},
      %Menu{label: "Read frinds", id: :read},
      %Menu{label: "update frinds", id: :update},
      %Menu{label: "Delete frinds", id: :delete}
    ]
end
