defmodule PhoenixCourse.UserControllerTest do
  @moduledoc false
  use PhoenixCourse.ConnCase
  alias PhoenixCourse.User

  defp user_count do
    Repo.one( from u in User, select: count(u.id) )
  end
end
