defmodule AcqdatApiWeb.StreamLogic.WorkflowController do
  use AcqdatApiWeb, :controller

  plug AcqdatApiWeb.Plug.LoadProject when action in [:index]
  plug AcqdatApiWeb.Plug.LoadStreamLogicWorkflow when action in [:update, :delete]

  def index(conn) do

  end

  def create(conn, params) do

  end

  def update(conn, params) do

  end

  def show(conn, params) do

  end

  def delete(conn, params) do

  end

end
