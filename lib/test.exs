defmodule PhoenixCourse.UserControllerTest do
  @moduledoc false
  use PhoenixCourse.ConnCase
  alias PhoenixCourse.User

  test "shows a new user page", %{conn: conn} do
    conn = get conn, user_path(conn, :new)

    assert html_response(conn, 200) =~ ~r/New User/
  end

  test "shows user page with tweets and follow button", %{conn: conn} do
    user = create_user(name: "Jimmy", username: "jimmy123")
    user |> create_tweet(message: "Jimmy talking.")
    conn = get conn, user_path(conn, :show, user)

    assert html_response(conn, 200) =~ ~r/Name: Jimmy/
    assert String.contains?(conn.resp_body, "Username: jimmy123")
    assert String.contains?(conn.resp_body, "Jimmy talking.")
    assert String.contains?(conn.resp_body, "Follow user")
  end

  test "creates a user and redirects to user path when params are valid", %{conn: conn} do
    valid_attrs = %{name: "Jimmy", username: "jimmy123", password: "safe123456"}
    users_before = user_count

    conn = post conn, user_path(conn, :create), %{user: valid_attrs}

    assert get_flash(conn, :info) == "User created!"
    assert redirected_to(conn) == user_path(conn, :new)
    assert last_user.name == "Jimmy"
    assert user_count == users_before + 1
  end

  test "renders error message when user params are invalid", %{conn: conn} do
    invalid_attrs = %{name: "", username: "", password: ""}
    users_before = user_count

    conn = post conn, user_path(conn, :create), %{user: invalid_attrs}

    assert html_response(conn, 200) =~
      ~r/Oops, something went wrong! Please check the errors below./
    assert user_count == users_before
  end

  defp last_user do
    Repo.one(from u in User, order_by: [desc: u.id], limit: 1)
  end

  defp user_count do
    Repo.one(  from u in User, select: count(u.id) )
  end
end
