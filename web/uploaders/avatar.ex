defmodule Vutuv.Avatar do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @versions [:original, :thumb, :medium, :large]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)


  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 64x64^ -gravity center -extent 64x64"}
  end

  def transform(:medium, _) do
    {:convert, "-strip -gravity center -resize 256x256^ -extent 256x256"}
  end

  def transform(:large, _) do
    {:convert, "-strip -gravity center -resize 512x512^ -extent 512x512"}
  end

  # Use local storage
  #
  def __storage, do: Arc.Storage.Local

  def filename(version,  {_file, scope}), do: "#{scope}_#{version}"

  def storage_dir(_version, {_file, scope}) do
    "web/static/assets/images/avatars/#{scope.id}"
  end

  def user_url(user, version) do
    Vutuv.Avatar.url({user.avatar, user}, version, signed: true)
    |>String.replace("web/static/assets", "")
  end

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
