defmodule Mix.Tasks.Deploy do
  use Mix.Task

  require Logger

  def run([]) do
    unless Mix.env() === :prod do
      raise "Run in PROD env, currently in #{Mix.env()}."
    end

    # Make sure we've got this compiled
    Mix.Task.run("compile")

    version = Keyword.fetch!(Mix.Project.config(), :version)

    Logger.info("Starting deploy of version '#{version}'.")

    try do
      deploy_version(version)
    rescue
      error ->
        Logger.error("Error deploying: #{inspect(error, pretty: true)}")
    end
  end

  defp deploy_version(version) do
    import Access, only: [at: 1, key: 1]

    Logger.info("Building code. This takes a while...")

    {_, 0} =
      System.cmd(
        "docker",
        [
          "build",
          "--build-arg",
          "APP_NAME=ferreira_rocks",
          "--build-arg",
          "APP_VSN=#{version}",
          "-f",
          "devops/docker/release.dockerfile",
          "-t",
          "ferreira_rocks:#{version}",
          "."
        ],
        into: IO.stream(:stdio, :line)
      )

    Logger.info("Done. Pushing image to GCP registry...")

    {_, 0} =
      System.cmd("docker",
        ["tag", "ferreira_rocks:#{version}", "eu.gcr.io/constant-cursor-295616/ferreira_rocks:#{version}"])

    {_, 0} =
      System.cmd("docker",
        ["push", "eu.gcr.io/constant-cursor-295616/ferreira_rocks:#{version}"])

    Logger.info("Done. Getting prod IP from terraform...")

    {terraform_show, 0} = System.cmd("terraform", ["-chdir=devops", "show", "-json"])
    infra = Jason.decode!(terraform_show)
    prod_ip =
      infra["values"]["root_module"]["resources"]
      |> Enum.find(fn
        %{"type" => "google_compute_instance"} -> true
        _ -> false
      end)
      |> get_in([key("values"), key("network_interface"), at(0), key("access_config"), at(0), key("nat_ip")])

    Logger.info("Done, found #{prod_ip}. Restarting container...")

    {_, 0} =
      System.cmd("ssh", [
        prod_ip,
        "docker kill $(docker ps -q) && " <>
        "docker rm $(docker ps -a -q) && " <>
        "docker run -d -p 80:80 eu.gcr.io/constant-cursor-295616/ferreira_rocks:#{version}"
      ])

    Logger.info("Up!")
  end
end
