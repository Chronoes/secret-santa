defmodule SecretSantaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SecretSantaWeb, :controller
      use SecretSantaWeb, :html

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(assets fonts img favicon.ico robots.txt)

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: SecretSantaWeb.Layouts]

      import Plug.Conn
      import SecretSantaWeb.Gettext
      alias SecretSantaWeb.Router.Helpers, as: Routes

      import SecretSantaWeb.CommonPlug, only: [layout_assigns: 2]

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {SecretSantaWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html_helpers() do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      import Phoenix.HTML

      import SecretSantaWeb.HTMLHelpers
      import SecretSantaWeb.ErrorHelpers
      import SecretSantaWeb.Gettext
      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS
      alias Phoenix.Flash
      alias SecretSantaWeb.Router.Helpers, as: Routes

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  # def channel do
  #   quote do
  #     use Phoenix.Channel
  #     import SecretSantaWeb.Gettext
  #   end
  # end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: SecretSantaWeb.Endpoint,
        router: SecretSantaWeb.Router,
        statics: SecretSantaWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
