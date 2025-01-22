defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    socket = assign(socket, form: to_form(Gists.change_gist(%Gist{})))
    {:ok, socket}
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    case(Gists.create_gist(socket.assigns.current_user, params)) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        # reset the form
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist.id]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        class="flex justify-center"
        phx-submit="create"
        phx-change="validate"
        phx-target={@myself}
      >
        <div class="flex w-4/5 flex-col gap-8">
          <.input
            field={@form[:description]}
            placeholder="Gist description..."
            autocomplete="off"
            phx-debounce="blur"
          />
          <div>
            <div class="bg-emDark flex items-center rounded-t-md border p-2">
              <div class="w-[300px] mb-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename including extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>

            <div id="gist-wrapper" class="flex" phx-update="ignore">
              <textarea
                id="line-numbers"
                class="line-numbers w-12 rounded-bl-md"
                id="line-numbers"
                readonly
              > 
                {"1\n"}
              </textarea>
              <.input
                id="gist-textarea"
                phx-hook="UpdateLineNumbers"
                container_class="flex-grow"
                field={@form[:markup_text]}
                placeholder="Insert code..."
                class="textarea"
                autocomplete="off"
                spellcheck="false"
                type="textarea"
                phx-debounce="blur"
              />
            </div>

            <div class="flex justify-end">
              <.button class="primary-button" phx-disable-with="Creating...">Create gist</.button>
            </div>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end
