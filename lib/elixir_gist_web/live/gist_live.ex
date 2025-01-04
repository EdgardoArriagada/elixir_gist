defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, socket}
  end
end
