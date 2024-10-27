defmodule LzhWeb.Admin.ElectionsLive.StatementsUploadForm do
  use LzhWeb, :live_component

  alias Lzh.{Politicians, Statements}
  alias Lzh.Statements.Statement

  #
  # life cycle
  #

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{election: election}, socket) do
    socket =
      socket
      |> assign(:election, election)
      |> assign(:csv_file, nil)
      |> allow_upload(:csv_file, accept: [".csv"])
      |> assign(:errors, [])

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("validate", %{} = _params, socket) do
    {:noreply, assign(socket, :errors, [])}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :csv_file, ref)}
  end

  @impl true
  def handle_event("save", %{} = _params, socket) do
    election = socket.assigns.election

    [data] =
      consume_uploaded_entries(socket, :csv_file, fn %{path: path}, _entry ->
        {:ok, parse_csv(path)}
      end)

    params_list =
      Enum.map(data, fn row ->
        prepare_create_statement_params(row, election)
      end)

    changesets =
      Enum.map(params_list, fn params ->
        %Statement{}
        |> Statements.change_statement(params)
        |> Map.put(:action, :validate)
      end)

    socket =
      if Enum.all?(changesets, fn changeset -> changeset.valid? end) do
        num_imported =
          params_list
          |> Enum.map(fn params ->
            {:ok, _statement} = Statements.create_statement(params)
          end)
          |> Enum.count()

        notify_parent({:saved, %{}})

        socket
        |> put_flash(:info, "#{num_imported} твърдения бяха добавени!")
        |> push_patch(to: ~p"/админ/избори/#{election.id}/твърдения", replace: true)
      else
        errors =
          changesets
          |> Enum.with_index(1)
          |> Enum.reject(fn {changeset, index} -> changeset.valid? end)
          |> Enum.map(fn {changeset, index} ->
            columns =
              changeset.errors
              |> Keyword.keys()
              |> Enum.join(", ")

            "В ред #{index} има проблем със следните колони: #{columns}."
          end)

        socket
        |> assign(:errors, errors)
      end

    {:noreply, socket}
  end

  #
  # data import
  #

  def parse_csv(path) do
    all_rows =
      File.stream!(path)
      |> CSV.decode!(escape_max_lines: 100)
      |> Enum.into([])

    [headers | rows] = all_rows

    Enum.map(rows, fn row ->
      row = Enum.map(row, &String.trim/1)

      headers
      |> Enum.zip(row)
      |> Enum.into(%{})
    end)
  end

  def prepare_create_statement_params(%{} = row, election) do
    avatar = Politicians.get_avatar(row["politician"], election)

    date =
      row["date"]
      |> String.split([".", "/"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> (fn numbers ->
            case numbers do
              [day, month, year] ->
                {:ok, date} = Date.new(year, month, day)
                date

              _ ->
                nil
            end
          end).()

    tv_show_minute =
      case Integer.parse(row["tv_show_minute"]) do
        {integer, _rest} -> integer
        :error -> "tv_show_minute is not a number"
      end

    sources =
      row
      |> Map.keys()
      |> Enum.filter(&String.starts_with?(&1, "source_"))
      |> Enum.sort()
      |> Enum.map(fn key -> row[key] end)
      |> Enum.reject(fn value -> value == "" end)

    %{
      avatar_id: if(avatar, do: avatar.id, else: nil),
      date: date,
      tv_show: row["tv_show"],
      tv_show_url: row["tv_show_url"],
      tv_show_minute: tv_show_minute,
      statement: row["statement"],
      context: row["context"],
      response: row["response"],
      sources: sources
    }
  end

  #
  # helpers
  #

  defp notify_parent(message) do
    send(self(), message)
  end
end
