defmodule LzhWeb.Admin.StatementsLive.FormComponent do
  use LzhWeb, :live_component

  alias Lzh.{Politicians, Statements}

  #
  # life cycle
  #

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:politicians_for_select, list_politicians_for_select())

    {:ok, socket}
  end

  @impl true
  def update(%{action: action, statement: statement, election: election}, socket) do
    changeset = Statements.change_statement(statement)

    socket =
      socket
      |> assign(:election, election)
      |> assign(:statement, statement)
      |> assign(:action, action)
      |> assign(:avatars_for_select, list_avatars_for_select(election))
      |> assign_form(changeset)

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("validate", %{"statement" => params}, socket) do
    params = Map.put(params, "sources", string_to_array(params["sources"]))

    changeset =
      socket.assigns.statement
      |> Statements.change_statement(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"statement" => statement_params}, socket) do
    save(socket, socket.assigns.action, statement_params)
  end

  #
  # helpers
  #

  defp list_politicians_for_select do
    wanted =
      MapSet.new([
        "Бойко Борисов",
        "Делян Добрев",
        "Росен Желязков",
        "Деница Сачева",
        "Даниел Митов",
        "Кирил Петков",
        "Асен Василев",
        "Даниел Лорер",
        "Стефан Тафров",
        "Христо Иванов",
        "Делян Пеевски",
        "Джевдет Чакъров",
        "Илхан Кючюк",
        "Йордан Цонев",
        "Костадин Костадинов",
        "Цончо Ганев",
        "Петър Волгин",
        "Корнелия Нинова",
        "Георги Свиленски",
        "Кристиан Вигенин",
        "Станислав Трифонов",
        "Тошко Хаджитодоров",
        "Ивайло Вълчев",
        "Станислав Балабанов"
      ])

    Politicians.list_politicians(preload_parties: true)
    |> Enum.filter(&MapSet.member?(wanted, &1.name))
    |> Enum.reject(&(&1.party.name == "Продължаваме промяната"))
    |> Enum.into(Keyword.new(), &{"#{&1.name} (#{&1.party.name})", &1.id})
  end

  defp list_avatars_for_select(election) do
    election
    |> Politicians.list_avatars()
    |> Enum.into(Keyword.new(), fn avatar ->
      {"#{avatar.politician.name} (#{avatar.party})", avatar.id}
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save(socket, :new, params) do
    params =
      params
      |> Map.put("election_id", socket.assigns.election.id)
      |> Map.put("sources", string_to_array(params["sources"]))

    socket =
      case Statements.create_statement(params) do
        {:ok, statement} ->
          notify_parent({:saved, statement})

          socket
          |> put_flash(:info, "Новото твърдение е добавено.")
          |> push_patch(to: ~p"/админ/твърдения")

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp save(socket, :edit, params) do
    params =
      params
      |> Map.put("sources", string_to_array(params["sources"]))

    socket =
      case Statements.update_statement(socket.assigns.statement, params) do
        {:ok, statement} ->
          notify_parent({:saved, statement})

          socket
          |> put_flash(:info, "Твърдението е запазено.")
          |> push_patch(to: ~p"/админ/твърдения")

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp string_to_array(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn line -> line != "" end)
  end

  defp array_to_string(nil), do: nil

  defp array_to_string(array) do
    Enum.join(array, "\n\n")
  end

  defp notify_parent(message) do
    send(self(), message)
  end
end
