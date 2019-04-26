defmodule Viztube.Queries do
  @moduledoc """
  The Queries context.
  """

  import Ecto.Query, warn: false
  alias Viztube.Repo

  alias Viztube.Queries.{Search, Result}

  @doc """
  Returns the list of searches.

  ## Examples

      iex> list_searches()
      [%Search{}, ...]

  """
  def list_searches do
    Repo.all(Search)
  end

  @doc """
  Returns the list of searches from an user

  ## Examples

      iex> list_searches(2)
      [%Search{}, ...]

  """
  def list_searches(id, page) do
    Search
    |> where([q], q.user_id == ^id)
    |> Repo.paginate(page: page, page_size: 50)
  end

  @doc """
  Gets a single search.

  Raises `Ecto.NoResultsError` if the Search does not exist.

  ## Examples

      iex> get_search!(123)
      %Search{}

      iex> get_search!(456)
      ** (Ecto.NoResultsError)

  """
  def get_search!(id) do
    Repo.get!(Search, id)
  end

  @doc """
  Creates a search.

  ## Examples

      iex> create_search(%{field: value})
      {:ok, %Search{}}

      iex> create_search(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_search(attrs \\ %{}) do
    %Search{}
    |> Search.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a search.

  ## Examples

      iex> update_search(search, %{field: new_value})
      {:ok, %Search{}}

      iex> update_search(search, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_search(%Search{} = search, attrs) do
    search
    |> Search.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Search.

  ## Examples

      iex> delete_search(search)
      {:ok, %Search{}}

      iex> delete_search(search)
      {:error, %Ecto.Changeset{}}

  """
  def delete_search(%Search{} = search) do
    Repo.delete(search)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking search changes.

  ## Examples

      iex> change_search(search)
      %Ecto.Changeset{source: %Search{}}

  """
  def change_search(%Search{} = search) do
    Search.changeset(search, %{})
  end

  @doc """
  Returns the list of results.

  ## Examples

      iex> list_results(34, 1)
      %{"entries" => [%Result{}, ...], "current_page" => integer, "total_pages" => integer... }

  """
  def list_results(id, page) do
    Result
    |> where([r], r.search_id == ^id)
    |> order_by([r], desc: fragment("?->>'published_at'", r.value))
    |> Repo.paginate(page: page, page_size: 50)
  end

  def get_results_count(id) do
    Viztube.Repo.aggregate(from(r in "results", where: r.search_id == ^id), :count, :id)
  end

  def get_query(user_id, id) do
    Search
    |> where(user_id: ^user_id, id: ^id)
    |> Repo.all
  end

  @doc """
  Gets a single result.

  Raises `Ecto.NoResultsError` if the Result does not exist.

  ## Examples

      iex> get_result!(123)
      %Result{}

      iex> get_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_result!(id), do: Repo.get!(Result, id)

  @doc """
  Creates a result for a saved search.
  Check if video exists in related search and save it if does not

  ## Examples

      iex> create_result(%{field: value})
      {:ok, %Result{}}

      iex> create_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_result(attrs \\ %{}) do
    Viztube.Queries.Result
      |> where(search_id: ^attrs.search_id)
      |> Repo.all
      |> Enum.find(fn(r) ->
          r.value.video_id == attrs.value.video_id
        end)
      |> save_result(attrs)
  end

  defp save_result(video, attrs) when video == nil do
    %Result{}
    |> Result.changeset(attrs)
    |> Repo.insert()
  end

  defp save_result(_video, attrs) do
    {:error, Result.changeset(%Result{}, attrs)}
  end

  @doc """
  Updates a result.

  ## Examples

      iex> update_result(result, %{field: new_value})
      {:ok, %Result{}}

      iex> update_result(result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_result(%Result{} = result, attrs) do
    result
    |> Result.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Result.

  ## Examples

      iex> delete_result(result)
      {:ok, %Result{}}

      iex> delete_result(result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_result(%Result{} = result) do
    Repo.delete(result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking result changes.

  ## Examples

      iex> change_result(result)
      %Ecto.Changeset{source: %Result{}}

  """
  def change_result(%Result{} = result) do
    Result.changeset(result, %{})
  end

end
