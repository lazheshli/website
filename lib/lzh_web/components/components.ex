defmodule LzhWeb.Components do
  @moduledoc """
  Our bigger UI components.
  """
  use Phoenix.Component

  import LzhWeb.CoreComponents

  attr :statement, :map, required: true

  def statement(%{} = assigns) do
    ~H"""
    <div class="w-full p-6 rounded-md border-2 border-zinc-200 my-4">
      <div class="w-full flex flex-row flex-wrap">
        <div class="basis-1/2 xl:basis-1/4 grow mb-4 flex flex-row">
          <.icon name="hero-user" class="block w-6 h-6 mt-1 mr-2" />
          <dl class="basis-full">
            <dt class="text-zinc-500">Кандидат</dt>
            <dd>
              <span class=""><%= @statement.politician.name %></span>
              (<%= @statement.politician.party.name %>)
            </dd>
          </dl>
        </div>

        <div class="basis-1/2 xl:basis-1/4 grow mb-4 flex flex-row">
          <.icon name="hero-tv" class="block w-6 h-6 mt-1 mr-2" />
          <dl class="basis-full">
            <dt class="text-zinc-500">Предаване</dt>
            <dd>
              <%= @statement.tv_show %> (<a
                href={@statement.tv_show_url}
                class="underline"
                title="Връзка към предаването"
              >връзка</a>)
            </dd>
          </dl>
        </div>

        <div class="basis-1/2 xl:basis-1/4 grow mb-4 flex flex-row">
          <.icon name="hero-calendar-days" class="block w-6 h-6 mt-1 mr-2" />
          <dl class="basis-full">
            <dt class="text-zinc-500">Дата на излъчване</dt>
            <dd><%= @statement.date %></dd>
          </dl>
        </div>

        <div class="basis-1/2 xl:basis-1/4 grow mb-4 flex flex-row">
          <.icon name="hero-clock" class="block w-6 h-6 mt-1 mr-2" />
          <dl class="basis-full">
            <dt class="text-zinc-500">Минута на изказване</dt>
            <dd>
              <%= @statement.tv_show_minute %> мин.
            </dd>
          </dl>
        </div>
      </div>

      <div class="w-full mb-4 flex flex-row">
        <.icon name="hero-chat-bubble-left-ellipsis" class="block w-6 h-6 mt-1 mr-2" />
        <dl class="basis-full">
          <dt class="text-zinc-500">Невярно твърдение</dt>
          <dd><%= @statement.statement %></dd>
        </dl>
      </div>

      <%= if String.trim(@statement.context) != "" do %>
        <div class="w-full mb-4 flex flex-row">
          <.icon name="hero-map" class="block w-6 h-6 mt-1 mr-2" />
          <dl class="basis-full">
            <dt class="text-zinc-500">Контекст на изказването</dt>
            <dd><%= @statement.context %></dd>
          </dl>
        </div>
      <% end %>

      <div class="w-full mb-4 flex flex-row">
        <.icon name="hero-check-circle" class="block w-6 h-6 mt-1 mr-2" />
        <dl class="basis-full">
          <dt class="text-zinc-500">Нашата аргументация</dt>
          <dd><%= @statement.response %></dd>
        </dl>
      </div>

      <div class="w-full flex flex-row">
        <.icon name="hero-book-open" class="block w-6 h-6 mt-1 mr-2" />
        <dl class="basis-full">
          <dt class="text-zinc-500">Източници</dt>
          <dd>
            <ul class="list-inside list-disc">
              <li :for={{source, index} <- Enum.with_index(@statement.sources, 1)}>
                <a
                  href={source}
                  target="_blank"
                  title={"Източник #{index}: #{source}"}
                  class="underline break-all"
                >
                  Източник <%= index %>
                </a>
              </li>
            </ul>
          </dd>
        </dl>
      </div>
    </div>
    """
  end
end
