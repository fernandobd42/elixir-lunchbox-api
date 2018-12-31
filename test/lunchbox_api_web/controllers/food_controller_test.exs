defmodule LunchboxApiWeb.FoodControllerTest do
  use LunchboxApiWeb.ConnCase

  alias LunchboxApi.Lunchbox
  alias LunchboxApi.Lunchbox.Food


  @create_attrs %{name: "some name", status: "some status"}
  @update_attrs %{name: "some updated name", status: "some updated status"}
  @invalid_attrs %{name: nil, status: nil}

  @username Application.get_env(:lunchbox_api, :lunchbox_auth)[:username]
  @password Application.get_env(:lunchbox_api, :lunchbox_auth)[:password]

  setup do
    conn =
      build_conn()
      |> using_basic_auth(@username, @password)
      |> put_req_header("accept", "application/json")

      {:ok, conn: conn}
    end

  def fixture(:food) do
    {:ok, food} = Lunchbox.create_food(@create_attrs)
    food
  end

  describe "index" do
    test "lists all foods", %{conn: conn} do
      conn = get conn, Routes.food_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create food" do
    test "renders food when data is valid", %{conn: conn} do
      conn = post conn, Routes.food_path(conn, :create), food: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn
      |> recycle_conn_auth()
      |> get(Routes.food_path(conn, :show, id))
      
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "status" => "some status"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.food_path(conn, :create), food: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update food" do
    setup [:create_food]

    test "renders food when data is valid", %{conn: conn, food: %Food{id: id} = food} do
      conn = put conn, Routes.food_path(conn, :update, food), food: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn
      |> recycle_conn_auth()
      |> get(Routes.food_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "status" => "some updated status"}
    end

    test "renders errors when data is invalid", %{conn: conn, food: food} do
      conn = put conn, Routes.food_path(conn, :update, food), food: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete food" do
    setup [:create_food]

    test "deletes chosen food", %{conn: conn, food: food} do
      conn = delete conn, Routes.food_path(conn, :delete, food)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        conn = conn
        |> recycle_conn_auth()
        |> get(Routes.food_path(conn, :show, food))
        conn
      end
    end
  end

  defp create_food(_) do
    food = fixture(:food)
    {:ok, food: food}
  end

  defp recycle_conn_auth(conn) do
    conn
    |> recycle()
    |> using_basic_auth(@username, @password)
    |> put_req_header("accept", "application/json")
  end

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

end
